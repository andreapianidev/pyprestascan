#!/usr/bin/env python3
"""
Demo dell'interfaccia grafica PyPrestaScan (versione semplificata)
"""
import sys
from pathlib import Path

# Aggiungi path progetto
current_dir = Path(__file__).parent
sys.path.insert(0, str(current_dir))

try:
    from PySide6.QtWidgets import (
        QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, 
        QGridLayout, QTabWidget, QGroupBox, QLabel, QLineEdit, QPushButton,
        QSpinBox, QCheckBox, QComboBox, QTextEdit, QProgressBar,
        QMessageBox, QFrame
    )
    from PySide6.QtCore import Qt, QTimer
    from PySide6.QtGui import QFont
except ImportError as e:
    print(f"❌ PySide6 non disponibile: {e}")
    sys.exit(1)


class PyPrestaScanDemo(QMainWindow):
    """Demo GUI PyPrestaScan"""
    
    def __init__(self):
        super().__init__()
        self.setWindowTitle("PyPrestaScan v1.0 - Demo Interface")
        self.setMinimumSize(800, 600)
        self._setup_ui()
    
    def _setup_ui(self):
        """Setup interfaccia utente"""
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        layout = QVBoxLayout(central_widget)
        
        # Header
        header = QLabel("🔍 PyPrestaScan - Analisi SEO PrestaShop")
        header.setStyleSheet("QLabel { font-size: 20px; font-weight: bold; margin: 10px; }")
        header.setAlignment(Qt.AlignCenter)
        layout.addWidget(header)
        
        # Tab widget
        tabs = QTabWidget()
        layout.addWidget(tabs)
        
        # Tab Configurazione
        config_tab = self._create_config_tab()
        tabs.addTab(config_tab, "⚙️ Configurazione")
        
        # Tab Progress (demo)
        progress_tab = self._create_progress_tab()
        tabs.addTab(progress_tab, "📈 Progress")
        
        # Tab Risultati (demo)  
        results_tab = self._create_results_tab()
        tabs.addTab(results_tab, "📊 Risultati")
        
        # Status bar
        self.statusBar().showMessage("Demo PyPrestaScan - Interfaccia funzionante ✅")
    
    def _create_config_tab(self):
        """Crea tab configurazione"""
        widget = QWidget()
        layout = QVBoxLayout(widget)
        
        # URL Group
        url_group = QGroupBox("🌐 Configurazione URL")
        url_layout = QGridLayout(url_group)
        
        url_layout.addWidget(QLabel("URL del sito:"), 0, 0)
        self.url_edit = QLineEdit()
        self.url_edit.setPlaceholderText("https://mio-shop-prestashop.com")
        self.url_edit.textChanged.connect(self._validate_url)
        url_layout.addWidget(self.url_edit, 0, 1)
        
        self.prestashop_check = QCheckBox("Modalità PrestaShop (euristiche specifiche)")
        self.prestashop_check.setChecked(True)
        url_layout.addWidget(self.prestashop_check, 1, 0, 1, 2)
        
        self.subdomains_check = QCheckBox("Includi sottodomini")
        url_layout.addWidget(self.subdomains_check, 2, 0, 1, 2)
        
        layout.addWidget(url_group)
        
        # Crawling Parameters
        crawl_group = QGroupBox("⚡ Parametri Scansione")
        crawl_layout = QGridLayout(crawl_group)
        
        crawl_layout.addWidget(QLabel("Max URL da scansionare:"), 0, 0)
        self.max_urls_spin = QSpinBox()
        self.max_urls_spin.setRange(1, 50000)
        self.max_urls_spin.setValue(1000)
        self.max_urls_spin.setSingleStep(100)
        crawl_layout.addWidget(self.max_urls_spin, 0, 1)
        
        crawl_layout.addWidget(QLabel("Richieste parallele:"), 1, 0)
        self.concurrency_spin = QSpinBox()
        self.concurrency_spin.setRange(1, 50)
        self.concurrency_spin.setValue(10)
        crawl_layout.addWidget(self.concurrency_spin, 1, 1)
        
        crawl_layout.addWidget(QLabel("Delay tra richieste (ms):"), 2, 0)
        self.delay_spin = QSpinBox()
        self.delay_spin.setRange(0, 2000)
        self.delay_spin.setValue(100)
        self.delay_spin.setSingleStep(50)
        crawl_layout.addWidget(self.delay_spin, 2, 1)
        
        layout.addWidget(crawl_group)
        
        # Progetto
        project_group = QGroupBox("📁 Gestione Progetto")
        project_layout = QGridLayout(project_group)
        
        project_layout.addWidget(QLabel("Nome progetto:"), 0, 0)
        self.project_edit = QLineEdit()
        self.project_edit.setText("demo-scan")
        project_layout.addWidget(self.project_edit, 0, 1)
        
        self.resume_check = QCheckBox("Riprendi scansione esistente")
        project_layout.addWidget(self.resume_check, 1, 0, 1, 2)
        
        layout.addWidget(project_group)
        
        # Bottoni azione
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        
        self.demo_btn = QPushButton("🎬 Demo Scansione")
        self.demo_btn.setStyleSheet("QPushButton { background-color: #4CAF50; color: white; font-weight: bold; padding: 10px; }")
        self.demo_btn.clicked.connect(self._run_demo)
        button_layout.addWidget(self.demo_btn)
        
        self.validate_btn = QPushButton("✅ Valida Configurazione")
        self.validate_btn.clicked.connect(self._validate_config)
        button_layout.addWidget(self.validate_btn)
        
        layout.addLayout(button_layout)
        layout.addStretch()
        
        return widget
    
    def _create_progress_tab(self):
        """Crea tab progress"""
        widget = QWidget()
        layout = QVBoxLayout(widget)
        
        # Progress info
        info_group = QGroupBox("📊 Stato Scansione")
        info_layout = QVBoxLayout(info_group)
        
        self.progress_bar = QProgressBar()
        self.progress_bar.setTextVisible(True)
        self.progress_bar.setValue(0)
        info_layout.addWidget(self.progress_bar)
        
        # Stats
        stats_layout = QGridLayout()
        self.pages_label = QLabel("Pagine scansionate: 0")
        self.issues_label = QLabel("Issues trovati: 0") 
        self.images_label = QLabel("Immagini analizzate: 0")
        self.time_label = QLabel("Tempo trascorso: 0s")
        
        stats_layout.addWidget(self.pages_label, 0, 0)
        stats_layout.addWidget(self.issues_label, 0, 1)
        stats_layout.addWidget(self.images_label, 1, 0)
        stats_layout.addWidget(self.time_label, 1, 1)
        
        info_layout.addLayout(stats_layout)
        layout.addWidget(info_group)
        
        # Log area
        log_group = QGroupBox("📝 Log Attività")
        log_layout = QVBoxLayout(log_group)
        
        self.log_text = QTextEdit()
        self.log_text.setReadOnly(True)
        self.log_text.setFont(QFont("Monaco", 10))
        self.log_text.append("=== Log PyPrestaScan ===")
        self.log_text.append("🚀 Sistema pronto per la scansione")
        self.log_text.append("💡 Configura i parametri e premi 'Demo Scansione'")
        
        log_layout.addWidget(self.log_text)
        layout.addWidget(log_group)
        
        return widget
    
    def _create_results_tab(self):
        """Crea tab risultati"""
        widget = QWidget()
        layout = QVBoxLayout(widget)
        
        # KPI Summary
        kpi_group = QGroupBox("📋 Riepilogo Analisi SEO")
        kpi_layout = QGridLayout(kpi_group)
        
        # KPI Cards (simulati)
        self.total_pages_label = QLabel("Pagine totali: --")
        self.success_rate_label = QLabel("Tasso successo: --")
        self.avg_score_label = QLabel("Score SEO medio: --")
        self.critical_issues_label = QLabel("Issues critici: --")
        
        kpi_layout.addWidget(self.total_pages_label, 0, 0)
        kpi_layout.addWidget(self.success_rate_label, 0, 1)
        kpi_layout.addWidget(self.avg_score_label, 1, 0)
        kpi_layout.addWidget(self.critical_issues_label, 1, 1)
        
        layout.addWidget(kpi_group)
        
        # Preview Issues
        issues_group = QGroupBox("⚠️ Top Issues Rilevati")
        issues_layout = QVBoxLayout(issues_group)
        
        self.issues_text = QTextEdit()
        self.issues_text.setReadOnly(True)
        self.issues_text.setMaximumHeight(200)
        self.issues_text.append("🔴 CRITICAL: 15 pagine senza title tag")
        self.issues_text.append("🟡 WARNING: 23 pagine con meta description mancante")
        self.issues_text.append("🟠 WARNING: 8 immagini prodotto senza ALT text")
        self.issues_text.append("🔵 INFO: 12 pagine senza OpenGraph image")
        self.issues_text.append("🔴 CRITICAL: 3 pagine cart indicizzabili (manca noindex)")
        
        issues_layout.addWidget(self.issues_text)
        layout.addWidget(issues_group)
        
        # Export buttons
        export_layout = QHBoxLayout()
        export_layout.addStretch()
        
        export_html_btn = QPushButton("📊 Apri Report HTML")
        export_html_btn.clicked.connect(lambda: self._show_info("Report HTML", "Funzionalità disponibile nella versione completa"))
        export_layout.addWidget(export_html_btn)
        
        export_csv_btn = QPushButton("📄 Esporta CSV")
        export_csv_btn.clicked.connect(lambda: self._show_info("Export CSV", "Export CSV disponibile nella versione completa"))
        export_layout.addWidget(export_csv_btn)
        
        layout.addLayout(export_layout)
        layout.addStretch()
        
        return widget
    
    def _validate_url(self):
        """Valida URL inserito"""
        url = self.url_edit.text().strip()
        if url and not url.startswith(('http://', 'https://')):
            self.statusBar().showMessage("⚠️ URL deve iniziare con http:// o https://")
        elif url:
            self.statusBar().showMessage(f"✅ URL valido: {url}")
        else:
            self.statusBar().showMessage("Demo PyPrestaScan - Inserisci URL per iniziare")
    
    def _validate_config(self):
        """Valida configurazione"""
        url = self.url_edit.text().strip()
        
        if not url:
            QMessageBox.warning(self, "Configurazione", "⚠️ Inserisci un URL per il sito da scansionare")
            return
        
        if not url.startswith(('http://', 'https://')):
            QMessageBox.warning(self, "Configurazione", "⚠️ URL deve iniziare con http:// o https://")
            return
        
        # Simulazione validazione
        config_summary = f"""
        ✅ Configurazione Valida
        
        📝 Parametri:
        • URL: {url}
        • Max URL: {self.max_urls_spin.value()}
        • Concorrenza: {self.concurrency_spin.value()}
        • Delay: {self.delay_spin.value()}ms
        • Progetto: {self.project_edit.text()}
        • PrestaShop: {'Sì' if self.prestashop_check.isChecked() else 'No'}
        
        🚀 Pronto per la scansione!
        """
        
        QMessageBox.information(self, "Configurazione", config_summary)
    
    def _run_demo(self):
        """Esegue demo scansione"""
        url = self.url_edit.text().strip()
        
        if not url:
            QMessageBox.warning(self, "Demo", "⚠️ Inserisci un URL prima di avviare la demo")
            return
        
        # Passa a tab progress
        self.centralWidget().findChild(QTabWidget).setCurrentIndex(1)
        
        # Simula scansione
        self.log_text.append(f"\n🚀 Avvio demo scansione per: {url}")
        self.log_text.append("📥 Controllo robots.txt...")
        self.log_text.append("🗺️ Ricerca sitemap.xml...")
        self.log_text.append("🔍 Inizio crawling...")
        
        # Configura timer per simulazione
        self.demo_timer = QTimer()
        self.demo_timer.timeout.connect(self._update_demo)
        self.demo_step = 0
        self.demo_timer.start(500)  # Update ogni 500ms
        
        # Disabilita bottone
        self.demo_btn.setEnabled(False)
        self.demo_btn.setText("🔄 Demo in corso...")
        
        self.statusBar().showMessage("🔄 Demo scansione in corso...")
    
    def _update_demo(self):
        """Aggiorna demo progress"""
        self.demo_step += 1
        
        # Simula progress
        progress = min(self.demo_step * 5, 100)
        self.progress_bar.setValue(progress)
        
        # Simula stats
        pages = min(self.demo_step * 2, 47)
        issues = min(self.demo_step * 1, 23)
        images = min(self.demo_step * 3, 89)
        
        self.pages_label.setText(f"Pagine scansionate: {pages}")
        self.issues_label.setText(f"Issues trovati: {issues}")
        self.images_label.setText(f"Immagini analizzate: {images}")
        self.time_label.setText(f"Tempo trascorso: {self.demo_step//2}s")
        
        # Log periodici
        if self.demo_step % 4 == 0:
            messages = [
                f"🔍 Scansionate {pages} pagine...",
                f"📊 Analizzate {images} immagini...",
                f"⚠️ Rilevati {issues} potenziali issues...",
                "🎯 Applicazione euristiche PrestaShop...",
                "📈 Calcolo score SEO per ogni pagina..."
            ]
            msg = messages[(self.demo_step // 4 - 1) % len(messages)]
            self.log_text.append(msg)
        
        # Fine demo
        if self.demo_step >= 20:  # 10 secondi
            self.demo_timer.stop()
            self._finish_demo()
    
    def _finish_demo(self):
        """Completa la demo"""
        # Final progress
        self.progress_bar.setValue(100)
        
        # Final stats
        self.pages_label.setText("Pagine scansionate: 47")
        self.issues_label.setText("Issues trovati: 23")
        self.images_label.setText("Immagini analizzate: 89")
        self.time_label.setText("Tempo trascorso: 10s")
        
        # Final log
        self.log_text.append("\n✅ Demo completata con successo!")
        self.log_text.append("📊 Generazione report HTML, CSV e JSON...")
        self.log_text.append("🎉 Tutti i report sono stati generati!")
        self.log_text.append("\n💡 Nella versione completa:")
        self.log_text.append("  • Crawling reale di siti PrestaShop")
        self.log_text.append("  • 25+ regole SEO specializzate")  
        self.log_text.append("  • Dashboard HTML interattiva")
        self.log_text.append("  • Export CSV/JSON completi")
        self.log_text.append("  • Supporto per siti con 50k+ pagine")
        
        # Aggiorna results tab
        self.total_pages_label.setText("Pagine totali: 47")
        self.success_rate_label.setText("Tasso successo: 94%")
        self.avg_score_label.setText("Score SEO medio: 72/100")
        self.critical_issues_label.setText("Issues critici: 5")
        
        # Riabilita bottone
        self.demo_btn.setEnabled(True)
        self.demo_btn.setText("🎬 Ripeti Demo")
        
        # Status
        self.statusBar().showMessage("✅ Demo completata - Passa a tab Risultati per vedere i dati!")
        
        # Passa a risultati
        QTimer.singleShot(2000, lambda: self.centralWidget().findChild(QTabWidget).setCurrentIndex(2))
    
    def _show_info(self, title, message):
        """Mostra info dialog"""
        QMessageBox.information(self, title, message)


def main():
    """Entry point demo"""
    app = QApplication(sys.argv)
    
    app.setApplicationName("PyPrestaScan Demo")
    app.setApplicationVersion("1.0.0")
    app.setStyle("Fusion")
    
    window = PyPrestaScanDemo()
    window.show()
    
    return app.exec()


if __name__ == '__main__':
    sys.exit(main())