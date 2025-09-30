#!/usr/bin/env python3
"""
Script di avvio per PyPrestaScan GUI
"""
import sys
import os
from pathlib import Path

def main():
    """Avvia l'interfaccia grafica"""
    
    # Aggiungi path progetto prima degli import
    current_dir = Path(__file__).parent
    sys.path.insert(0, str(current_dir))
    
    # Verifica dipendenze PySide6
    try:
        from PySide6.QtWidgets import QApplication
        print("✅ PySide6 trovato")
    except ImportError:
        print("❌ PySide6 non trovato!")
        print("\n💡 Per installarlo:")
        print("pip install PySide6")
        print("\nOppure installa tutte le dipendenze GUI:")
        print("pip install -r requirements-gui.txt")
        return 1
    
    try:
        print("🚀 Avvio PyPrestaScan GUI...")
        from pyprestascan.gui.main_window import main as gui_main
        return gui_main()
        
    except ImportError as e:
        print(f"❌ Errore import moduli: {e}")
        print(f"Percorso corrente: {current_dir}")
        print(f"Sys.path: {sys.path[:3]}...")  # Prime 3 entry
        print("\n💡 Assicurati di aver installato tutte le dipendenze:")
        print("pip install -r requirements.txt")
        return 1
    
    except Exception as e:
        print(f"❌ Errore nell'avvio GUI: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())