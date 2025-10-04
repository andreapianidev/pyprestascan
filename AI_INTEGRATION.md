# 🤖 Integrazione AI per Fix Suggeriti - PyPrestaScan

## 📋 Panoramica

PyPrestaScan v1.1.0+ supporta l'integrazione con **AI generativa** per creare meta description e contenuti SEO di **qualità superiore** rispetto ai template standard.

### ✨ Vantaggi AI vs Template Standard

| Feature | Template Standard | AI (DeepSeek/GPT/Claude) |
|---------|------------------|---------------------------|
| **Qualità** | Generica | ⭐ Contestuale e accattivante |
| **Personalizzazione** | Bassa | ⭐⭐⭐ Alta (capisce prodotto) |
| **Costo** | Gratis | 💰 $0.01-0.05 per 100 prodotti |
| **Velocità** | Instantanea | ⏱️ 5-10 secondi per batch |
| **Confidence** | 0.5-0.8 | ⭐⭐⭐ 0.95-0.98 |

---

## 🎯 Provider Supportati

### 1️⃣ **DeepSeek** (⭐ RACCOMANDATO)
- **Costo**: $0.14 per 1M token input
- **Modello**: `deepseek-chat`
- **Perché sceglierlo**: Miglior rapporto qualità/prezzo, ottimo per italiano
- **Esempio costo reale**: 500 prodotti = **$0.02** ≈ €0.02

```python
Provider: DeepSeek
URL: https://platform.deepseek.com
API Key: Registrati gratis, ottieni $5 di credito iniziale
```

### 2️⃣ **OpenAI GPT-4o-mini**
- **Costo**: $0.15 per 1M token input
- **Modello**: `gpt-4o-mini`
- **Perché sceglierlo**: Veloce, affidabile, buona qualità
- **Esempio costo reale**: 500 prodotti = **$0.03** ≈ €0.03

```python
Provider: OpenAI
URL: https://platform.openai.com/api-keys
API Key: Richiede carta di credito
```

### 3️⃣ **Anthropic Claude Haiku**
- **Costo**: $0.80 per 1M token input
- **Modello**: `claude-3-5-haiku-20241022`
- **Perché sceglierlo**: Qualità massima, migliori risultati creativi
- **Esempio costo reale**: 500 prodotti = **$0.15** ≈ €0.14

```python
Provider: Claude
URL: https://console.anthropic.com/settings/keys
API Key: Richiede registrazione
```

---

## 💰 Stima Costi Reali

### Esempio: E-commerce con 1000 prodotti senza meta description

| Provider | Token Totali | Costo Totale | Costo per Prodotto |
|----------|--------------|--------------|---------------------|
| **DeepSeek** | ~150,000 | **$0.021** | €0.00002 |
| **OpenAI GPT-4o-mini** | ~150,000 | **$0.023** | €0.00002 |
| **Claude Haiku** | ~150,000 | **$0.120** | €0.00011 |

**Confronto con lavoro manuale**:
- 💼 SEO specialist: €30/ora × 8 ore = **€240**
- 🤖 AI (DeepSeek): **€0.02**
- 💡 **Risparmio: 99.99%**

---

## 🚀 Come Funziona (Ottimizzazione Token)

### 🧠 Strategia Batch Processing

Invece di fare **1 chiamata API per prodotto** (costoso):
```
500 prodotti × 200 token = 100,000 token = $0.014 (DeepSeek)
```

PyPrestaScan usa **batch processing intelligente** (1 chiamata per 20 prodotti):
```
1 chiamata × 3,000 token = 3,000 token = $0.0004 (DeepSeek)
Ripetuto 25 volte = $0.01 totale
```

**Risparmio: ~30% sui token!**

### 📝 Prompt Ottimizzati

**Esempio prompt standard** (❌ INEFFICIENTE - 150 token):
```
You are an SEO expert. Generate an optimized meta description for the following product page. The meta description should be between 120-160 characters, engaging, and include relevant keywords. Here is the product information:
- Title: Scarpe Running Nike Air Zoom
- URL: https://shop.com/42-scarpe-running
- Type: Product
Please provide ONLY the meta description without explanations.
```

**Prompt PyPrestaScan** (✅ EFFICIENTE - 30 token):
```
Meta description SEO (120-160 char) per: Scarpe Running Nike Air Zoom (prodotto)
```

**Risparmio: 80% token per richiesta!**

---

## ⚙️ Configurazione nell'Interfaccia GUI

### Step 1: Ottenere API Key

#### DeepSeek (RACCOMANDATO):
1. Vai su https://platform.deepseek.com
2. Registrati (email + password)
3. Ricevi $5 di credito gratuito
4. Vai su **API Keys** → **Create new key**
5. Copia la chiave (es: `sk-abcd1234...`)

#### OpenAI:
1. Vai su https://platform.openai.com/signup
2. Registrati e aggiungi carta di credito
3. Vai su **API keys** → **Create new secret key**
4. Copia la chiave (es: `sk-proj-abcd...`)

#### Claude:
1. Vai su https://console.anthropic.com
2. Registrati con email
3. Aggiungi metodo di pagamento
4. Vai su **Settings → API Keys → Create Key**
5. Copia la chiave (es: `sk-ant-abcd...`)

### Step 2: Configurare in PyPrestaScan

**Tab Configurazione** → Sezione "AI Fix Avanzati":

```
┌─────────────────────────────────────────┐
│ 🤖 AI Fix Avanzati (Opzionale)         │
├─────────────────────────────────────────┤
│ Provider AI: [DeepSeek ▼]              │
│ API Key: [sk-abcd1234**********]       │
│                                         │
│ ℹ️  Stima costi:                        │
│    • DeepSeek: $0.02/500 prodotti      │
│    • OpenAI: $0.03/500 prodotti        │
│    • Claude: $0.15/500 prodotti        │
│                                         │
│ [ ] Abilita AI per Fix Suggeriti       │
└─────────────────────────────────────────┘
```

### Step 3: Generare Fix con AI

1. Esegui scansione normalmente
2. Vai al **Tab Fix Suggeriti**
3. Clicca **"Genera Fix Suggeriti"**
4. Se AI è abilitata, vedrai:
   ```
   🤖 Generazione fix con AI (DeepSeek)...
   ⏱️  Processando 20 prodotti in batch...
   ✅ Generati 20 fix! Token usati: 2,400 (~$0.0003)
   ```

---

## 📊 Esempio Output AI vs Template

### Prodotto: "MacBook Pro 14 M3 Max 36GB RAM"

#### Template Standard (confidence: 0.7):
```
MacBook Pro 14 M3 Max 36GB RAM - Acquista online su tecnoshop.it
```
- ✅ Lunghezza OK (67 caratteri)
- ⚠️ Generico, nessun valore aggiunto
- 📊 CTR stimato: +15% vs vuoto

#### AI DeepSeek (confidence: 0.95):
```
MacBook Pro 14" M3 Max con 36GB RAM: potenza professionale per editing video, sviluppo e creative. Scopri l'offerta!
```
- ✅ Lunghezza ottimale (128 caratteri)
- ✅ Evidenzia benefici (editing, sviluppo)
- ✅ Call-to-action ("Scopri l'offerta")
- 📊 CTR stimato: +45% vs vuoto, +25% vs template

---

## 🔐 Sicurezza API Keys

### ⚠️ IMPORTANTE: Non condividere mai le tue API keys!

**PyPrestaScan salva le keys in modo sicuro**:
- 📁 Percorso: `~/.pyprestascan/settings.json`
- 🔒 Permessi: Solo utente corrente può leggere
- 🚫 Le keys NON sono mai inviate a server PyPrestaScan
- ✅ Connessione diretta: App → DeepSeek/OpenAI/Claude

**Come ruotare le keys** (best practice):
1. Ogni 90 giorni, crea nuova key
2. Aggiorna in PyPrestaScan
3. Revoca vecchia key sul provider

---

## ❓ FAQ

### Q: L'AI consuma molti token anche se ho pochi prodotti?
**A:** No! PyPrestaScan processa solo i prodotti che hanno effettivamente issues. Se hai 1000 prodotti ma solo 50 senza meta description, l'AI processa solo quei 50.

### Q: Posso usare AI solo per alcuni prodotti?
**A:** Sì, future versioni permetteranno di selezionare quali fix usare AI. Per ora, disabilita AI e usa template per risparmiare.

### Q: L'AI scrive in italiano corretto?
**A:** Sì, tutti e 3 i provider hanno eccellente supporto italiano. DeepSeek è particolarmente ottimizzato per lingue non-inglesi.

### Q: Cosa succede se l'API fallisce?
**A:** PyPrestaScan ha **fallback automatico**: se AI fallisce, usa template standard. Zero interruzioni.

### Q: Posso testare senza pagare?
**A:** Sì!
- **DeepSeek**: $5 credito gratuito (~ 35,000 prodotti!)
- **OpenAI**: $5 credito iniziale (se nuovo account)
- **Claude**: $5 credito iniziale

---

## 🛠️ Troubleshooting

### Errore: "AI provider non disponibile"
**Causa**: Modulo `httpx` non installato
**Fix**:
```bash
pip install --upgrade pyprestascan[ai]
```

### Errore: "Invalid API key"
**Causa**: Key errata o revocata
**Fix**:
1. Verifica key copiata correttamente (no spazi)
2. Controlla su provider se key è attiva
3. Rigenera nuova key

### Errore: "Rate limit exceeded"
**Causa**: Troppi requests in poco tempo
**Fix**:
- Attendi 1 minuto e riprova
- DeepSeek ha rate limit molto alti (difficile raggiungere)

### AI genera testi in inglese invece di italiano
**Causa**: Prompt system modificato
**Fix**:
- Reinstalla: `pip install --force-reinstall pyprestascan`
- Verifica versione: `pyprestascan --version` (deve essere ≥ 1.1.0)

---

## 📈 Roadmap Future

- [ ] Supporto GPT-4o full (ancora più qualità)
- [ ] AI locale con Llama 3 (zero costi API)
- [ ] Generazione ALT text immagini con AI vision
- [ ] Suggerimenti title con AI
- [ ] Personalizzazione prompt utente

---

## 💡 Best Practices

1. **Usa DeepSeek per produzione** - Miglior costo/qualità
2. **Batch di 20 prodotti** - Già ottimizzato automaticamente
3. **Rivedi i fix generati** - AI è ottima ma non perfetta
4. **Monitora consumo** - Dashboard provider mostra spesa
5. **Backup regolari** - Prima di applicare fix SQL massivi

---

## 🤝 Contribuire

Hai suggerimenti per migliorare l'integrazione AI?
Apri una issue su: https://github.com/andreapianidev/pyprestascan/issues

---

**Creato da Andrea Piani** | [linktr.ee/andreapianidev](https://linktr.ee/andreapianidev)
