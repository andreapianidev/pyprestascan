#!/bin/bash
echo "🚀 Avvio PyPrestaScan Demo GUI..."
echo ""

# Controlla se siamo nella directory corretta
if [ ! -f "demo_gui.py" ]; then
    echo "❌ Errore: Esegui questo script dalla directory del progetto PyPrestaFix"
    exit 1
fi

# Attiva environment virtuale se esiste
if [ -d "venv" ]; then
    echo "📦 Attivazione ambiente virtuale..."
    source venv/bin/activate
    
    # Controlla PySide6
    if ! python -c "import PySide6" 2>/dev/null; then
        echo "⚠️  PySide6 non trovato nell'ambiente virtuale"
        echo "🔧 Installazione dipendenze GUI..."
        pip install -r requirements-minimal.txt
    fi
fi

echo "🎬 Avvio interfaccia grafica..."
echo "💡 Una finestra di PyPrestaScan si aprirà a breve"
echo ""

# Avvia GUI
python demo_gui.py

echo ""
echo "✅ Demo completata!"
echo "🙏 Grazie per aver testato PyPrestaScan!"