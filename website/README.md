# PyPrestaScan Website

Sito web di presentazione per PyPrestaScan - Scanner SEO professionale per PrestaShop.

## 📁 Struttura

```
website/
├── index.html          # Pagina principale
├── style.css           # Stili CSS
├── script.js           # JavaScript per interazioni
└── README.md           # Questo file
```

## 🚀 Come Usare

### Visualizzazione Locale

Apri semplicemente `index.html` nel tuo browser:

```bash
# macOS
open website/index.html

# Linux
xdg-open website/index.html

# Windows
start website/index.html
```

### Server Locale (Opzionale)

Se preferisci usare un server web locale:

```bash
# Python 3
cd website
python3 -m http.server 8000

# Poi apri http://localhost:8000 nel browser
```

## 🎨 Caratteristiche del Sito

- **Design moderno e responsive** - Perfetto su desktop, tablet e mobile
- **Animazioni fluide** - Elementi animati allo scroll
- **Navigazione smooth** - Scroll fluido tra sezioni
- **Code blocks copiabili** - Click per copiare i comandi
- **Gradient accattivanti** - Colori moderni e professionali
- **SEO-friendly** - Meta tag ottimizzati

## 📋 Sezioni

1. **Hero** - Introduzione con screenshot e call-to-action
2. **Features** - 8 card con tutte le funzionalità principali
3. **How It Works** - 3 step per iniziare
4. **Installation** - Guida installazione con esempi di codice
5. **AI Features** - Confronto AI vs template standard
6. **Documentation** - Link a tutti i documenti
7. **CTA** - Call-to-action finale
8. **Footer** - Link utili e informazioni autore

## 🎨 Personalizzazione

### Colori

I colori principali sono definiti in `:root` nel file `style.css`:

```css
--primary: #2563eb;
--secondary: #8b5cf6;
--success: #10b981;
--gradient-2: linear-gradient(135deg, #2563eb 0%, #8b5cf6 100%);
```

### Font

Il sito usa **Inter** da Google Fonts. Per cambiarlo, modifica il link nel `<head>` di `index.html`.

## 📤 Deploy

### GitHub Pages

1. Crea un repository `pyprestascan-website`
2. Pusha il contenuto della cartella `website/`
3. Vai su Settings > Pages
4. Seleziona branch `main` e cartella `/` (root)
5. Il sito sarà disponibile su `https://tuousername.github.io/pyprestascan-website/`

### Netlify / Vercel

1. Connetti il repository
2. Build command: (nessuno, è statico)
3. Publish directory: `website/`
4. Deploy automatico!

### Hosting Tradizionale

Carica i file via FTP nella cartella public_html del tuo hosting.

## 🔧 Manutenzione

### Aggiornare la Versione

Modifica la versione in:
- `index.html` (sezione hero-stats e footer)
- Badge "Latest Version"

### Aggiungere Nuove Features

1. Aggiungi una nuova card nella sezione `.features-grid`
2. Mantieni la struttura esistente per consistenza
3. Usa icone emoji per semplicità

## 📸 Screenshot

Lo screenshot principale è caricato su:
```
https://www.andreapiani.com/pyprestascan.png
```

Per usare un'immagine locale:
1. Salva l'immagine in `website/assets/images/`
2. Modifica il path in `index.html`:
   ```html
   <img src="assets/images/pyprestascan.png" alt="...">
   ```

## 🤝 Contributi

Per migliorare il sito:
1. Modifica i file HTML/CSS/JS
2. Testa localmente
3. Crea una pull request

## 📝 License

Stesso del progetto principale: MIT License

---

**Autore:** Andrea Piani - [linktr.ee/andreapianidev](http://linktr.ee/andreapianidev)
