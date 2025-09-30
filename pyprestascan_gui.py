#!/usr/bin/env python3
"""
PyPrestaScan - Interfaccia Grafica Reale
Avvia la GUI con scansioni effettive e profili personalizzabili
"""
import sys
from pathlib import Path

def main():
    """Avvia PyPrestaScan GUI"""
    
    print("🚀 Avvio PyPrestaScan GUI...")
    
    # Aggiungi path progetto
    current_dir = Path(__file__).parent
    sys.path.insert(0, str(current_dir))
    
    try:
        # Test dipendenze
        from PySide6.QtWidgets import QApplication
        print("✅ PySide6 OK")
        
        # Import GUI
        from pyprestascan.gui.real_gui import main as gui_main
        print("✅ Moduli PyPrestaScan caricati")
        
        print("\n🎯 Caratteristiche GUI:")
        print("• 📋 7 profili di scansione predefiniti")
        print("• ⚡ Scansione Veloce (500 URL, 5-15 min)")
        print("• 🔍 Scansione Completa (10k URL, 30-60 min)")
        print("• 🖼️ Focus Immagini ALT")
        print("• 🔧 SEO Tecnico")
        print("• 🛒 PrestaShop Specifico")
        print("• 📝 Analisi Contenuti")
        print("• 🚀 Performance & UX")
        print("\n💡 Seleziona il profilo in base alle tue necessità!")
        print("\n🌐 L'interfaccia si aprirà a breve...")
        
        return gui_main()
        
    except ImportError as e:
        print(f"\n❌ Errore import: {e}")
        print("\n🔧 Soluzioni:")
        print("1. Attiva ambiente virtuale: source venv/bin/activate")
        print("2. Installa dipendenze: pip install -r requirements-minimal.txt")
        print("3. Verifica Python 3.11+: python --version")
        return 1
    
    except Exception as e:
        print(f"\n❌ Errore avvio: {e}")
        print("\n💡 Riprova o usa la CLI: python -m pyprestascan --help")
        return 1


if __name__ == '__main__':
    sys.exit(main())