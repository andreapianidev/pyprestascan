# 🚀 PyPrestaScan - Guida Interfaccia Grafica

## ✅ Status: GUI Attiva e Funzionante

L'interfaccia grafica di PyPrestaScan è stata **avviata con successo** e ora è disponibile per l'uso con **scansioni reali**.

## 🎯 Caratteristiche Implementate

### 📋 7 Profili di Scansione Predefiniti

1. **🔍 Scansione Completa** - Analisi SEO completa (10k URL, 30-60 min)
2. **⚡ Scansione Veloce** - Controllo rapido pagine principali (500 URL, 5-15 min)  
3. **🖼️ Focus Immagini ALT** - Specifica per testo alternativo (5k URL, 15-30 min)
4. **🔧 SEO Tecnico** - Canonical, robots, sitemap (3k URL, 20-40 min)
5. **🛒 PrestaShop Specifico** - Configurazioni tipiche PS (2k URL, 15-35 min)
6. **📝 Analisi Contenuti** - Qualità contenuti, duplicati (4k URL, 25-45 min)
7. **🚀 Performance & UX** - Prestazioni e user experience (1.5k URL, 10-25 min)

### 🖥️ Interfaccia Completa

- **Tab Avvio Scansione**: Inserimento URL, selezione profilo, avvio
- **Tab Progress**: Monitoraggio in tempo reale, statistiche, log attività
- **Tab Risultati**: KPI, issues trovati, export CSV/JSON/HTML

## 🎮 Come Usare

### 1. Avvio Rapido
L'interfaccia è **già aperta** e pronta all'uso. Se dovessi riavviarla:

```bash
cd "/Users/andreapiani/Library/Mobile Documents/com~apple~CloudDocs/Prototipi/PyPrestaFix"
source venv/bin/activate
python pyprestascan_gui.py
```

### 2. Scansione Veloce (Consigliata per iniziare)
1. Inserisci URL del tuo shop PrestaShop (es: `https://mio-shop.com`)
2. Clicca **⚡ Veloce** per una scansione rapida 
3. Vai al tab **📈 Progress** per monitorare
4. Ricevi risultati in **📊 Risultati** dopo 5-15 minuti

### 3. Scansione Personalizzata
1. Clicca **⚙️ Seleziona Profilo Personalizzato**
2. Scegli dal dialog con 7 opzioni disponibili
3. Leggi dettagli e focus areas del profilo
4. Avvia con **🚀 AVVIA SCANSIONE**

## 📊 Output e Report

Ogni scansione genera automaticamente:

- **📄 Report HTML**: Visualizzazione completa con grafici
- **📊 File CSV**: Dati strutturati per analisi
- **📋 File JSON**: Dati machine-readable
- **📝 Log dettagliato**: Tracciabilità completa del processo

I file vengono salvati in `./reports/` e sono accessibili tramite i pulsanti nell'interfaccia.

## 🔧 Configurazione Avanzata

### Pattern Include/Exclude Personalizzati

Ogni profilo ha pattern regex predefiniti:

```python
# Esempio patterns per PrestaShop
include_patterns = [
    r".*-p\d+\.html",      # Pagine prodotto
    r".*-c\d+\.html",      # Pagine categoria
]

exclude_patterns = [
    r"\?.*orderby=",       # Filtri ordinamento
    r"\?.*page=",         # Paginazione
    r"/admin/.*",         # Area admin
]
```

### Concorrenza e Rate Limiting

- **Quick**: 25 request parallele, delay 100ms
- **Complete**: 15 request parallele, delay 200ms  
- **Technical**: 15 request parallele, delay 200ms

## 🎯 Suggerimenti d'Uso

### Per Nuovi Siti
1. Inizia con **⚡ Scansione Veloce**
2. Analizza i risultati preliminari
3. Procedi con **🔍 Scansione Completa** se soddisfatto

### Per Problemi Specifici
- **🖼️ Immagini ALT mancanti** → `Focus Immagini ALT`
- **🔧 Problemi tecnici** → `SEO Tecnico`
- **🛒 Issues PrestaShop** → `PrestaShop Specifico`
- **📝 Contenuti duplicati** → `Analisi Contenuti`

### Per Audit Performance
- **🚀 Performance & UX** per Core Web Vitals e velocità

## 📋 Prossimi Passi

1. **Testa l'interfaccia** con un URL di esempio
2. **Sperimenta i profili** diversi per capire le differenze  
3. **Analizza i report** generati per familiarizzare con l'output
4. **Personalizza le configurazioni** modificando i profili se necessario

---

## 💡 Note Tecniche

- **Python**: 3.13 con venv attivo
- **Dependencies**: PySide6, pandas, httpx, aiolimiter, selectolax
- **Storage**: SQLite per resume e persistenza dati
- **Export**: Jinja2 templates per HTML, pandas per CSV
- **Logging**: Rich logger con emoji e colori

**🎉 L'interfaccia è completamente funzionante e pronta per scansioni reali!**