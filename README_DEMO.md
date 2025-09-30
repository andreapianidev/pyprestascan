# 🎬 PyPrestaScan - Demo Interface Grafica

Benvenuto alla **demo dell'interfaccia grafica** di PyPrestaScan!

## 🚀 Avvio Rapido

### Metodo 1: Script Automatico
```bash
./start_demo.sh
```

### Metodo 2: Manuale
```bash
# Attiva ambiente virtuale
source venv/bin/activate

# Avvia demo
python demo_gui.py
```

### Metodo 3: Senza ambiente virtuale
```bash
# Installa PySide6 se necessario
pip install PySide6

# Avvia demo
python demo_gui.py
```

## 🎯 Cosa Puoi Testare

### Tab 1: ⚙️ Configurazione
- ✅ **Inserimento URL**: Prova con `https://demo.prestashop.com`
- ✅ **Parametri Scansione**: Max URLs, concorrenza, delay
- ✅ **Modalità PrestaShop**: Euristiche specifiche e-commerce
- ✅ **Gestione Progetto**: Nome progetto e resume
- ✅ **Validazione**: Bottone "Valida Configurazione"

### Tab 2: 📈 Progress & Log  
- 🎬 **Demo Animata**: Bottone "Demo Scansione" (10 secondi)
- 📊 **Progress Bar**: Avanzamento in tempo reale
- 📈 **Statistiche Live**: Pagine, issues, immagini analizzate
- 📝 **Log Colorato**: Messaggi di sistema con emoji

### Tab 3: 📊 Risultati
- 📋 **KPI Summary**: Metriche principali dopo la demo
- ⚠️ **Top Issues**: Issues SEO più frequenti
- 📄 **Export**: Bottoni per report (informativi)

## ✨ Caratteristiche Demo

### 🎨 UI/UX
- **Design moderno**: Interfaccia pulita con PySide6
- **Tab organizzati**: Workflow logico configurazione → progress → risultati
- **Validazione real-time**: Controlli immediati sui parametri
- **Status bar**: Feedback continuo all'utente
- **Responsive**: Si adatta a diverse dimensioni finestra

### 🎬 Simulazione Realistica
- **Progress animato**: 10 secondi di demo crawling
- **Log realistici**: Messaggi tipici di una scansione reale
- **Statistiche dinamiche**: Contatori che crescono nel tempo
- **Transizioni smooth**: Passaggio automatico tra tab

### 🛠️ Configurazione Completa
- **Tutti i parametri CLI**: Accessibili tramite interfaccia
- **Validazione robusta**: Controlli su URL e parametri
- **Preset intelligenti**: Valori di default ottimali
- **Help contestuale**: Tooltip e placeholder informativi

## 🎯 Scenario di Test Consigliato

1. **Avvia la demo**: `./start_demo.sh` o `python demo_gui.py`

2. **Configura target**:
   - URL: `https://demo.prestashop.com`
   - Max URLs: `1000` 
   - Concorrenza: `10`
   - Modalità PrestaShop: ✅ Abilitata

3. **Valida configurazione**: Premi "✅ Valida Configurazione"

4. **Avvia demo**: Premi "🎬 Demo Scansione" 

5. **Osserva progress**: 
   - Progress bar che avanza
   - Statistiche che crescono
   - Log dettagliati con emoji

6. **Vedi risultati**:
   - KPI finali
   - Top issues rilevati
   - Pulsanti export (informativi)

## 🎯 Confronto CLI vs GUI

| Aspetto | CLI | GUI Demo |
|---------|-----|----------|
| **Configurazione** | 40+ parametri da riga comando | Form organizzati e validati |
| **Progress** | Output testuale con emoji | Progress bar + statistiche live |  
| **Log** | Terminale con colori | Area dedicata con scroll |
| **Risultati** | File CSV/JSON/HTML | Preview integrata + export |
| **Usabilità** | Per power users | Per tutti gli utenti |
| **Workflow** | Lineare | Guided con tab |

## 🚀 Versione Completa (Non Demo)

La versione completa includerebbe:

### 🔧 Funzionalità Core
- **Crawling reale** di siti PrestaShop live
- **25+ regole SEO** specializzate per e-commerce
- **Database SQLite** per resume e persistenza
- **Export completi** CSV, JSON, HTML con dati reali
- **Supporto 50k+ URL** con ottimizzazioni performance

### 🎯 Analisi PrestaShop
- **Rilevamento automatico** versioni 1.6, 1.7, 8, 9
- **Euristiche prodotto/categoria** specifiche
- **Controllo multilingua** con hreflang
- **Analisi filtri faceted** e duplicati
- **Scoring SEO** calibrato per e-commerce

### 📊 Report Avanzati  
- **Dashboard HTML** interattiva con Chart.js
- **DataTables** filtrabili e ordinabili
- **KPI specializzati** per PrestaShop
- **Export programmabile** via API

## 🎨 Screenshots Interfaccia

La demo mostra:
- **Tab Configurazione**: Form organizzati per tutti i parametri
- **Tab Progress**: Progress bar, statistiche live, log colorato
- **Tab Risultati**: KPI summary, top issues, bottoni export
- **Status bar**: Feedback continuo sullo stato
- **Design moderno**: Stile Fusion con colori e icone

## 💻 Requisiti Sistema

- **Python**: 3.11+ (testato su 3.13)  
- **PySide6**: 6.6.0+ (installazione automatica)
- **Sistema**: Windows, macOS, Linux
- **RAM**: 100MB per la demo
- **Risoluzione**: Minimo 800x600

## 🐛 Risoluzione Problemi

### ❌ "PySide6 non trovato"
```bash
pip install PySide6
# oppure
pip install -r requirements-minimal.txt
```

### ❌ "Errore import moduli"
```bash
# Verifica environment Python
which python
python --version

# Reinstalla dipendenze
pip install --upgrade PySide6
```

### ❌ GUI non si apre
- Verifica di essere su sistema con interfaccia grafica
- Su macOS: assicurati che Terminal abbia permessi accessibilità
- Su Linux: verifica X11/Wayland funzionante

## 🎉 Prossimi Passi

Dopo aver testato la demo:

1. **Esplora il codice**: `pyprestascan/gui/main_window.py`
2. **Testa CLI**: `python -m pyprestascan --help`
3. **Leggi documentazione**: `README.md` principale  
4. **Contribuisci**: Feedback e pull request benvenuti!

---

**🔍 PyPrestaScan** - *Analisi SEO PrestaShop professionale con interfaccia moderna*