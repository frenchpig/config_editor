import sys
import os
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import shutil
from datetime import datetime
from dotenv import load_dotenv

class ConfigManagerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Config Manager")
        self.root.geometry("600x500")
        self.root.configure(bg="#1e1e2e")  # Dark theme background

        # Style configuration
        self.style = ttk.Style()
        self.style.theme_use('clam')
        
        # Configure colors for dark theme
        self.style.configure("TFrame", background="#1e1e2e")
        self.style.configure("TLabel", background="#1e1e2e", foreground="#cdd6f4", font=("Segoe UI", 10))
        self.style.configure("TButton", 
                             background="#313244", 
                             foreground="#cdd6f4", 
                             borderwidth=0, 
                             font=("Segoe UI", 10, "bold"),
                             padding=10)
        self.style.map("TButton",
                       background=[('active', '#45475a')],
                       foreground=[('active', '#ffffff')])
        
        self.style.configure("Header.TLabel", font=("Segoe UI", 16, "bold"), foreground="#89b4fa")

        # Base paths
        if getattr(sys, 'frozen', False):
            # Running as compiled binary
            self.base_dir = os.path.dirname(sys.executable)
            # If running from dist/, scripts are likely in the parent directory
            if os.path.basename(self.base_dir) == 'dist':
                self.base_dir = os.path.dirname(self.base_dir)
        else:
            self.base_dir = os.path.dirname(os.path.abspath(__file__))

        # Cargar variables de entorno desde .env
        env_path = os.path.join(self.base_dir, ".env")
        if os.path.exists(env_path):
            load_dotenv(env_path)
        
        # Configurar valores por defecto si no están definidos
        self.user_home = os.getenv("USER_HOME") or os.path.expanduser("~")
        self.config_dir = os.getenv("CONFIG_DIR") or ".config"
        
        self.backup_dir = os.path.join(self.base_dir, "backups")
        self.editions_dir = os.path.join(self.base_dir, "editions")

        self.create_widgets()

    def create_widgets(self):
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        # Header
        header = ttk.Label(main_frame, text="Configuration Manager", style="Header.TLabel")
        header.pack(pady=(0, 20))

        # Actions Frame
        actions_frame = ttk.LabelFrame(main_frame, text="Actions", padding="10")
        actions_frame.pack(fill=tk.X, pady=10)
        
        # Custom style for LabelFrame
        # Note: ttk LabelFrame styling is tricky, keeping it simple for now or using standard frame

        btn_frame = ttk.Frame(actions_frame)
        btn_frame.pack(fill=tk.X)

        self.btn_backup = ttk.Button(btn_frame, text="Backup Configs", command=self.run_backup)
        self.btn_backup.pack(side=tk.LEFT, padx=5, expand=True, fill=tk.X)

        self.btn_deploy = ttk.Button(btn_frame, text="Deploy Configs", command=self.run_deploy)
        self.btn_deploy.pack(side=tk.LEFT, padx=5, expand=True, fill=tk.X)

        # Restore Section
        restore_frame = ttk.LabelFrame(main_frame, text="Restore Backup", padding="10")
        restore_frame.pack(fill=tk.X, pady=20)

        ttk.Label(restore_frame, text="Select Backup:").pack(anchor=tk.W, pady=(0, 5))

        self.backup_var = tk.StringVar()
        self.backup_combo = ttk.Combobox(restore_frame, textvariable=self.backup_var, state="readonly")
        self.backup_combo.pack(fill=tk.X, pady=(0, 10))
        self.refresh_backups()

        self.btn_restore = ttk.Button(restore_frame, text="Restore Selected", command=self.run_restore)
        self.btn_restore.pack(fill=tk.X)

        # Log Area
        log_frame = ttk.LabelFrame(main_frame, text="Log Output", padding="10")
        log_frame.pack(fill=tk.BOTH, expand=True, pady=10)

        self.log_area = scrolledtext.ScrolledText(log_frame, height=10, bg="#181825", fg="#a6adc8", font=("Consolas", 9), relief=tk.FLAT)
        self.log_area.pack(fill=tk.BOTH, expand=True)

    def log(self, message):
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.log_area.insert(tk.END, f"[{timestamp}] {message}\n")
        self.log_area.see(tk.END)

    def refresh_backups(self):
        if os.path.exists(self.backup_dir):
            backups = sorted([d for d in os.listdir(self.backup_dir) if os.path.isdir(os.path.join(self.backup_dir, d))], reverse=True)
            self.backup_combo['values'] = backups
            if backups:
                self.backup_combo.current(0)
        else:
            self.backup_combo['values'] = []

    def run_script(self, script_name):
        script_path = os.path.join(self.base_dir, script_name)
        if not os.path.exists(script_path):
            self.log(f"Error: Script {script_name} not found.")
            return

        self.log(f"Running {script_name}...")
        try:
            process = subprocess.Popen([script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            stdout, stderr = process.communicate()
            
            if stdout:
                self.log_area.insert(tk.END, stdout)
            if stderr:
                self.log_area.insert(tk.END, f"ERROR: {stderr}")
            
            if process.returncode == 0:
                self.log(f"Success: {script_name} completed.")
            else:
                self.log(f"Failed: {script_name} exited with code {process.returncode}")
            
            self.log_area.see(tk.END)
            self.refresh_backups() # Refresh in case backup created new folder
        except Exception as e:
            self.log(f"Exception: {str(e)}")

    def run_backup(self):
        self.run_script("backup_configs.sh")

    def run_deploy(self):
        self.run_script("deploy_configs.sh")

    def run_restore(self):
        selected_backup = self.backup_var.get()
        if not selected_backup:
            messagebox.showwarning("Warning", "Please select a backup to restore.")
            return

        if not messagebox.askyesno("Confirm Restore", f"Are you sure you want to restore backup '{selected_backup}'?\nThis will overwrite current configurations."):
            return

        src_dir = os.path.join(self.backup_dir, selected_backup)
        if not os.path.exists(src_dir):
            self.log(f"Error: Backup directory {src_dir} not found.")
            return

        self.log(f"Restoring from: {selected_backup}")
        
        try:
            # Python implementation of restore logic to avoid interactive shell script
            for item in os.listdir(src_dir):
                src_item = os.path.join(src_dir, item)
                
                # Caso especial: dolphinrc debe restaurarse como archivo, no como directorio
                if item == "dolphin" and os.path.isdir(src_item):
                    dolphinrc_src = os.path.join(src_item, "dolphinrc")
                    if os.path.exists(dolphinrc_src):
                        target_path = os.path.join(self.user_home, self.config_dir, "dolphinrc")
                        
                        if os.path.exists(target_path):
                            timestamp = datetime.now().strftime("%Y%m%d_%H%M")
                            backup_path = f"{target_path}.old_{timestamp}"
                            shutil.move(target_path, backup_path)
                            self.log(f"Backed up existing dolphinrc to {os.path.basename(backup_path)}")
                        
                        shutil.copy2(dolphinrc_src, target_path)
                        self.log(f"Restored: dolphinrc")
                    continue
                
                target_name = item
                target_path = os.path.join(self.user_home, self.config_dir, target_name)
                
                if os.path.exists(target_path):
                    timestamp = datetime.now().strftime("%Y%m%d_%H%M")
                    backup_path = f"{target_path}.old_{timestamp}"
                    shutil.move(target_path, backup_path)
                    self.log(f"Backed up existing {target_name} to {os.path.basename(backup_path)}")

                if os.path.isdir(src_item):
                    shutil.copytree(src_item, target_path)
                else:
                    shutil.copy2(src_item, target_path)
                
                self.log(f"Restored: {target_name}")

            self.log("Restore completed successfully.")
            messagebox.showinfo("Success", "Configuration restored successfully!")

        except Exception as e:
            self.log(f"Error during restore: {str(e)}")
            messagebox.showerror("Error", f"An error occurred: {str(e)}")

if __name__ == "__main__":
    root = tk.Tk()
    app = ConfigManagerApp(root)
    root.mainloop()
