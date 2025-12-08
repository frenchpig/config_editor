#!/usr/bin/env python3
"""
Config Manager - PyQt6 Version
Configuration management application with Frutiger Aero styling
"""

import sys
import os
import subprocess
import shutil
from datetime import datetime

from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QLabel, QPushButton, QComboBox, QTextEdit, QGroupBox, QMessageBox,
    QSizePolicy
)
from PyQt6.QtCore import Qt, QThread, pyqtSignal, QProcess
from PyQt6.QtGui import QFont, QTextCursor

from dotenv import load_dotenv


# Frutiger Aero 3D Style Sheet (Matching Waybar)
STYLESHEET = """
/* ============================================
   Main Window - Aero Glass Effect
   ============================================ */
QMainWindow, QWidget {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 1, y2: 1,
        stop: 0 rgba(173, 216, 230, 230),
        stop: 0.5 rgba(144, 238, 144, 210),
        stop: 1 rgba(175, 238, 238, 230)
    );
    color: rgba(30, 50, 70, 245);
    font-family: "Roboto", "Segoe UI", "Ubuntu", sans-serif;
    font-size: 10pt;
}

/* ============================================
   Header Label
   ============================================ */
QLabel#header {
    color: rgba(30, 50, 70, 255);
    font-size: 18pt;
    font-weight: bold;
    padding: 10px;
    background: transparent;
}

/* ============================================
   Group Boxes - Glass Panel Effect
   ============================================ */
QGroupBox {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 100),
        stop: 0.5 rgba(255, 255, 255, 60),
        stop: 1 rgba(173, 216, 230, 80)
    );
    border: 1px solid rgba(255, 255, 255, 80);
    border-radius: 16px;
    margin-top: 16px;
    padding: 15px;
    padding-top: 25px;
    font-weight: bold;
}

QGroupBox::title {
    subcontrol-origin: margin;
    subcontrol-position: top left;
    padding: 4px 12px;
    color: rgba(30, 50, 70, 245);
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 200),
        stop: 1 rgba(200, 255, 255, 150)
    );
    border: 1px solid rgba(255, 255, 255, 120);
    border-radius: 10px;
    font-size: 11pt;
    font-weight: 600;
}

/* ============================================
   Glass Buttons - 3D Bubble Style (Waybar Match)
   ============================================ */
QPushButton {
    /* Rounded pill shape */
    border-radius: 16px;
    padding: 10px 20px;
    min-height: 24px;
    
    /* 3D Convex gradient */
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 130),
        stop: 0.5 rgba(255, 255, 255, 75),
        stop: 1 rgba(173, 216, 230, 100)
    );
    
    /* Glass border */
    border: 1px solid rgba(255, 255, 255, 80);
    
    /* Text styling */
    color: rgba(30, 50, 70, 245);
    font-weight: 600;
    font-size: 10pt;
}

QPushButton:hover {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 180),
        stop: 0.5 rgba(255, 255, 255, 115),
        stop: 1 rgba(173, 216, 230, 130)
    );
    border: 1px solid rgba(255, 255, 255, 150);
    color: rgba(30, 50, 70, 255);
}

QPushButton:pressed {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 220),
        stop: 0.5 rgba(173, 216, 230, 180),
        stop: 1 rgba(200, 255, 255, 190)
    );
    border: 2px solid rgba(255, 255, 255, 230);
    color: rgba(30, 50, 70, 255);
}

QPushButton:disabled {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(200, 200, 200, 80),
        stop: 1 rgba(180, 180, 180, 60)
    );
    color: rgba(100, 100, 100, 180);
    border: 1px solid rgba(200, 200, 200, 60);
}

/* ============================================
   Combo Box - Glass Dropdown
   ============================================ */
QComboBox {
    border-radius: 12px;
    padding: 8px 12px;
    min-height: 20px;
    
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 100),
        stop: 0.5 rgba(255, 255, 255, 65),
        stop: 1 rgba(173, 216, 230, 80)
    );
    
    border: 1px solid rgba(255, 255, 255, 80);
    color: rgba(30, 50, 70, 245);
    font-weight: 500;
}

QComboBox:hover {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 150),
        stop: 0.5 rgba(255, 255, 255, 90),
        stop: 1 rgba(173, 216, 230, 100)
    );
    border: 1px solid rgba(255, 255, 255, 120);
}

QComboBox::drop-down {
    border: none;
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 120),
        stop: 1 rgba(173, 216, 230, 100)
    );
    width: 30px;
    border-top-right-radius: 12px;
    border-bottom-right-radius: 12px;
}

QComboBox::down-arrow {
    width: 12px;
    height: 12px;
}

QComboBox QAbstractItemView {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 245),
        stop: 1 rgba(230, 255, 255, 230)
    );
    color: rgba(30, 50, 70, 245);
    selection-background-color: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(173, 216, 230, 180),
        stop: 1 rgba(200, 255, 255, 160)
    );
    selection-color: rgba(30, 50, 70, 255);
    border: 1px solid rgba(255, 255, 255, 150);
    border-radius: 8px;
    padding: 4px;
}

/* ============================================
   Text Edit (Log Area) - Glass Panel
   ============================================ */
QTextEdit {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 180),
        stop: 1 rgba(230, 255, 255, 160)
    );
    color: rgba(30, 50, 70, 245);
    border: 1px solid rgba(255, 255, 255, 120);
    border-radius: 12px;
    font-family: "Consolas", "Ubuntu Mono", monospace;
    font-size: 9pt;
    padding: 10px;
    selection-background-color: rgba(173, 216, 230, 180);
    selection-color: rgba(30, 50, 70, 255);
}

/* ============================================
   Scroll Bars - Glass Style
   ============================================ */
QScrollBar:vertical {
    background: rgba(255, 255, 255, 60);
    width: 12px;
    border-radius: 6px;
    margin: 2px;
}

QScrollBar::handle:vertical {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 1, y2: 0,
        stop: 0 rgba(255, 255, 255, 180),
        stop: 0.5 rgba(173, 216, 230, 150),
        stop: 1 rgba(255, 255, 255, 180)
    );
    border-radius: 5px;
    min-height: 30px;
    border: 1px solid rgba(255, 255, 255, 100);
}

QScrollBar::handle:vertical:hover {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 1, y2: 0,
        stop: 0 rgba(255, 255, 255, 220),
        stop: 0.5 rgba(200, 255, 255, 200),
        stop: 1 rgba(255, 255, 255, 220)
    );
}

QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical {
    height: 0;
}

QScrollBar:horizontal {
    background: rgba(255, 255, 255, 60);
    height: 12px;
    border-radius: 6px;
    margin: 2px;
}

QScrollBar::handle:horizontal {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 180),
        stop: 0.5 rgba(173, 216, 230, 150),
        stop: 1 rgba(255, 255, 255, 180)
    );
    border-radius: 5px;
    min-width: 30px;
    border: 1px solid rgba(255, 255, 255, 100);
}

QScrollBar::handle:horizontal:hover {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 220),
        stop: 0.5 rgba(200, 255, 255, 200),
        stop: 1 rgba(255, 255, 255, 220)
    );
}

QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal {
    width: 0;
}

/* ============================================
   Message Box Styling
   ============================================ */
QMessageBox {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 1, y2: 1,
        stop: 0 rgba(255, 255, 255, 245),
        stop: 1 rgba(230, 255, 255, 235)
    );
}

QMessageBox QLabel {
    color: rgba(30, 50, 70, 245);
    background: transparent;
}

/* ============================================
   Tooltips - Glass Bubble
   ============================================ */
QToolTip {
    background: qlineargradient(
        x1: 0, y1: 0, x2: 0, y2: 1,
        stop: 0 rgba(255, 255, 255, 245),
        stop: 1 rgba(230, 255, 255, 230)
    );
    border: 1px solid rgba(255, 255, 255, 150);
    border-radius: 10px;
    color: rgba(30, 50, 70, 245);
    padding: 6px 10px;
}

/* ============================================
   Labels
   ============================================ */
QLabel {
    color: rgba(30, 50, 70, 245);
    background: transparent;
    font-weight: 500;
}
"""


class ScriptRunner(QThread):
    """Thread for running shell scripts without blocking the UI"""
    output_received = pyqtSignal(str)
    finished_with_result = pyqtSignal(str, int)  # script_name, return_code
    
    def __init__(self, script_path, script_name):
        super().__init__()
        self.script_path = script_path
        self.script_name = script_name
        
    def run(self):
        try:
            process = subprocess.Popen(
                [self.script_path],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1
            )
            
            for line in iter(process.stdout.readline, ''):
                if line:
                    self.output_received.emit(line.rstrip())
            
            process.wait()
            self.finished_with_result.emit(self.script_name, process.returncode)
            
        except Exception as e:
            self.output_received.emit(f"Exception: {str(e)}")
            self.finished_with_result.emit(self.script_name, -1)


class ConfigManagerApp(QMainWindow):
    def __init__(self):
        super().__init__()
        
        self.setWindowTitle("Config Manager")
        self.setMinimumSize(600, 500)
        self.resize(650, 550)
        
        # Base paths
        if getattr(sys, 'frozen', False):
            self.base_dir = os.path.dirname(sys.executable)
            if os.path.basename(self.base_dir) == 'dist':
                self.base_dir = os.path.dirname(self.base_dir)
        else:
            self.base_dir = os.path.dirname(os.path.abspath(__file__))
        
        # Load environment variables
        env_path = os.path.join(self.base_dir, ".env")
        if os.path.exists(env_path):
            load_dotenv(env_path)
        
        # Configure default values
        self.user_home = os.getenv("USER_HOME") or os.path.expanduser("~")
        self.config_dir = os.getenv("CONFIG_DIR") or ".config"
        self.backup_dir = os.path.join(self.base_dir, "backups")
        self.editions_dir = os.path.join(self.base_dir, "editions")
        
        self.script_runner = None
        
        self.setup_ui()
        self.refresh_backups()
        
    def setup_ui(self):
        # Central widget
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        # Main layout
        main_layout = QVBoxLayout(central_widget)
        main_layout.setContentsMargins(20, 20, 20, 20)
        main_layout.setSpacing(15)
        
        # Header
        header = QLabel("Configuration Manager")
        header.setObjectName("header")
        header.setAlignment(Qt.AlignmentFlag.AlignCenter)
        main_layout.addWidget(header)
        
        # Actions Group
        actions_group = QGroupBox("Actions")
        actions_layout = QHBoxLayout(actions_group)
        actions_layout.setSpacing(10)
        
        self.btn_backup = QPushButton("Backup Configs")
        self.btn_backup.setCursor(Qt.CursorShape.PointingHandCursor)
        self.btn_backup.clicked.connect(self.run_backup)
        actions_layout.addWidget(self.btn_backup)
        
        self.btn_deploy = QPushButton("Deploy Configs")
        self.btn_deploy.setCursor(Qt.CursorShape.PointingHandCursor)
        self.btn_deploy.clicked.connect(self.run_deploy)
        actions_layout.addWidget(self.btn_deploy)
        
        main_layout.addWidget(actions_group)
        
        # Restore Group
        restore_group = QGroupBox("Restore Backup")
        restore_layout = QVBoxLayout(restore_group)
        restore_layout.setSpacing(10)
        
        label = QLabel("Select Backup:")
        restore_layout.addWidget(label)
        
        self.backup_combo = QComboBox()
        self.backup_combo.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)
        restore_layout.addWidget(self.backup_combo)
        
        self.btn_restore = QPushButton("Restore Selected")
        self.btn_restore.setCursor(Qt.CursorShape.PointingHandCursor)
        self.btn_restore.clicked.connect(self.run_restore)
        restore_layout.addWidget(self.btn_restore)
        
        main_layout.addWidget(restore_group)
        
        # Log Group
        log_group = QGroupBox("Log Output")
        log_layout = QVBoxLayout(log_group)
        
        self.log_area = QTextEdit()
        self.log_area.setReadOnly(True)
        self.log_area.setMinimumHeight(150)
        log_layout.addWidget(self.log_area)
        
        main_layout.addWidget(log_group, stretch=1)
        
    def log(self, message):
        """Add timestamped message to log area"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.log_area.append(f"[{timestamp}] {message}")
        # Auto-scroll to bottom
        cursor = self.log_area.textCursor()
        cursor.movePosition(QTextCursor.MoveOperation.End)
        self.log_area.setTextCursor(cursor)
        
    def refresh_backups(self):
        """Refresh the backup combo box"""
        self.backup_combo.clear()
        if os.path.exists(self.backup_dir):
            backups = sorted(
                [d for d in os.listdir(self.backup_dir) 
                 if os.path.isdir(os.path.join(self.backup_dir, d))],
                reverse=True
            )
            self.backup_combo.addItems(backups)
            
    def set_buttons_enabled(self, enabled):
        """Enable or disable action buttons"""
        self.btn_backup.setEnabled(enabled)
        self.btn_deploy.setEnabled(enabled)
        self.btn_restore.setEnabled(enabled)
        
    def run_script(self, script_name):
        """Run a shell script in a separate thread"""
        script_path = os.path.join(self.base_dir, script_name)
        
        if not os.path.exists(script_path):
            self.log(f"Error: Script {script_name} not found.")
            return
        
        self.log(f"Running {script_name}...")
        self.set_buttons_enabled(False)
        
        self.script_runner = ScriptRunner(script_path, script_name)
        self.script_runner.output_received.connect(self.on_script_output)
        self.script_runner.finished_with_result.connect(self.on_script_finished)
        self.script_runner.start()
        
    def on_script_output(self, line):
        """Handle script output line"""
        self.log_area.append(line)
        cursor = self.log_area.textCursor()
        cursor.movePosition(QTextCursor.MoveOperation.End)
        self.log_area.setTextCursor(cursor)
        
    def on_script_finished(self, script_name, return_code):
        """Handle script completion"""
        if return_code == 0:
            self.log(f"Success: {script_name} completed.")
        else:
            self.log(f"Failed: {script_name} exited with code {return_code}")
        
        self.set_buttons_enabled(True)
        self.refresh_backups()
        
    def run_backup(self):
        self.run_script("backup_configs.sh")
        
    def run_deploy(self):
        self.run_script("deploy_configs.sh")
        
    def run_restore(self):
        """Restore selected backup"""
        selected_backup = self.backup_combo.currentText()
        
        if not selected_backup:
            QMessageBox.warning(self, "Warning", "Please select a backup to restore.")
            return
        
        reply = QMessageBox.question(
            self, 
            "Confirm Restore",
            f"Are you sure you want to restore backup '{selected_backup}'?\n"
            "This will overwrite current configurations.",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No,
            QMessageBox.StandardButton.No
        )
        
        if reply != QMessageBox.StandardButton.Yes:
            return
            
        src_dir = os.path.join(self.backup_dir, selected_backup)
        if not os.path.exists(src_dir):
            self.log(f"Error: Backup directory {src_dir} not found.")
            return
            
        self.log(f"Restoring from: {selected_backup}")
        self.set_buttons_enabled(False)
        
        try:
            for item in os.listdir(src_dir):
                src_item = os.path.join(src_dir, item)
                
                # Special case: dolphinrc
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
                        self.log("Restored: dolphinrc")
                    continue
                
                # Special case: zsh - .zshrc goes to $HOME, not .config
                if item == "zsh" and os.path.isdir(src_item):
                    zshrc_src = os.path.join(src_item, ".zshrc")
                    if os.path.exists(zshrc_src):
                        target_path = os.path.join(self.user_home, ".zshrc")
                        
                        if os.path.exists(target_path):
                            timestamp = datetime.now().strftime("%Y%m%d_%H%M")
                            backup_path = f"{target_path}.old_{timestamp}"
                            shutil.move(target_path, backup_path)
                            self.log(f"Backed up existing .zshrc to {os.path.basename(backup_path)}")
                        
                        shutil.copy2(zshrc_src, target_path)
                        self.log("Restored: .zshrc")
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
            QMessageBox.information(self, "Success", "Configuration restored successfully!")
            
        except Exception as e:
            self.log(f"Error during restore: {str(e)}")
            QMessageBox.critical(self, "Error", f"An error occurred: {str(e)}")
        
        finally:
            self.set_buttons_enabled(True)


def main():
    # High DPI scaling
    app = QApplication(sys.argv)
    app.setStyleSheet(STYLESHEET)
    
    window = ConfigManagerApp()
    window.show()
    
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
