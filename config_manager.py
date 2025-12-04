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
        self.root.configure(bg="#2A4A52")

        self.style = ttk.Style()
        self.style.theme_use('clam')
        
        self.style.configure("TFrame", background="#2A4A52")
        self.style.configure("TLabel", background="#2A4A52", foreground="#E0F7FA", font=("Segoe UI", 10))
        
        self.style.configure("Header.TLabel", font=("Segoe UI", 18, "bold"), foreground="#4ECDC4")
        
        self.style.configure("TLabelframe", background="#2A4A52", foreground="#E0F7FA", borderwidth=2, relief=tk.RAISED, bordercolor="#458588")
        self.style.configure("TLabelframe.Label", background="#2A4A52", foreground="#4ECDC4", font=("Segoe UI", 11, "bold"))
        
        self.style.configure("TCombobox", 
                             fieldbackground="#3A5A62", 
                             background="#3A5A62", 
                             foreground="#E0F7FA",
                             borderwidth=1,
                             relief=tk.SOLID,
                             bordercolor="#458588")
        self.style.map("TCombobox",
                       fieldbackground=[('readonly', '#3A5A62')],
                       background=[('readonly', '#3A5A62')],
                       foreground=[('readonly', '#E0F7FA')],
                       bordercolor=[('focus', '#4ECDC4')])

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
    
    def create_glass_button(self, parent, text, command):
        container = tk.Frame(parent, bg="#2A4A52")
        
        shadow = tk.Frame(container, bg="#1E3246", height=2)
        shadow.pack(fill=tk.X, side=tk.BOTTOM)
        
        btn = tk.Button(container,
                        text=text,
                        command=command,
                        bg="#458588",
                        fg="#E0F7FA",
                        activebackground="#4ECDC4",
                        activeforeground="#2A4A52",
                        font=("Segoe UI", 10, "bold"),
                        relief=tk.FLAT,
                        borderwidth=0,
                        highlightthickness=2,
                        highlightbackground="#E0F7FA",
                        highlightcolor="#FFFFFF",
                        padx=15,
                        pady=12,
                        cursor="hand2")
        
        def on_enter(e):
            btn.configure(bg="#4ECDC4", fg="#2A4A52", highlightbackground="#FFFFFF", highlightcolor="#FFFFFF")
            shadow.configure(bg="#3A5A62", height=3)
        def on_leave(e):
            btn.configure(bg="#458588", fg="#E0F7FA", highlightbackground="#E0F7FA", highlightcolor="#E0F7FA")
            shadow.configure(bg="#1E3246", height=2)
        def on_press(e):
            btn.configure(bg="#74C0FC", fg="#2A4A52", highlightbackground="#FFFFFF")
            shadow.configure(bg="#1E3246", height=1)
        def on_release(e):
            if btn.cget("bg") == "#74C0FC":
                btn.configure(bg="#4ECDC4", fg="#2A4A52", highlightbackground="#FFFFFF")
                shadow.configure(bg="#3A5A62", height=3)
        
        btn.pack(fill=tk.BOTH, expand=True)
        btn.bind("<Enter>", on_enter)
        btn.bind("<Leave>", on_leave)
        btn.bind("<Button-1>", on_press)
        btn.bind("<ButtonRelease-1>", on_release)
        
        return container

    def create_widgets(self):
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        header_frame = tk.Frame(main_frame, bg="#2A4A52")
        header_frame.pack(fill=tk.X, pady=(0, 20))
        
        header = tk.Label(header_frame, 
                         text="Configuration Manager", 
                         font=("Segoe UI", 18, "bold"), 
                         fg="#4ECDC4", 
                         bg="#2A4A52")
        header.pack()

        # Actions Frame
        actions_frame = ttk.LabelFrame(main_frame, text="Actions", padding="10")
        actions_frame.pack(fill=tk.X, pady=10)
        
        # Custom style for LabelFrame
        # Note: ttk LabelFrame styling is tricky, keeping it simple for now or using standard frame

        btn_frame = tk.Frame(actions_frame, bg="#2A4A52")
        btn_frame.pack(fill=tk.X)

        self.btn_backup = self.create_glass_button(btn_frame, "Backup Configs", self.run_backup)
        self.btn_backup.pack(side=tk.LEFT, padx=5, expand=True, fill=tk.BOTH)

        self.btn_deploy = self.create_glass_button(btn_frame, "Deploy Configs", self.run_deploy)
        self.btn_deploy.pack(side=tk.LEFT, padx=5, expand=True, fill=tk.BOTH)

        # Restore Section
        restore_frame = ttk.LabelFrame(main_frame, text="Restore Backup", padding="10")
        restore_frame.pack(fill=tk.X, pady=20)

        ttk.Label(restore_frame, text="Select Backup:").pack(anchor=tk.W, pady=(0, 5))

        self.backup_var = tk.StringVar()
        self.backup_combo = ttk.Combobox(restore_frame, textvariable=self.backup_var, state="readonly")
        self.backup_combo.pack(fill=tk.X, pady=(0, 10))
        self.refresh_backups()

        self.btn_restore = self.create_glass_button(restore_frame, "Restore Selected", self.run_restore)
        self.btn_restore.pack(fill=tk.X)

        # Log Area
        log_frame = ttk.LabelFrame(main_frame, text="Log Output", padding="10")
        log_frame.pack(fill=tk.BOTH, expand=True, pady=10)

        self.log_area = scrolledtext.ScrolledText(log_frame, height=10, bg="#3A5A62", fg="#E0F7FA", font=("Consolas", 9), relief=tk.FLAT, insertbackground="#E0F7FA")
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
