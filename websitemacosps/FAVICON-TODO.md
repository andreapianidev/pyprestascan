# TODO: Generare Favicon

Per completare l'ottimizzazione SEO al 95/100, devi creare i favicon.

## Come generare i favicon:

### Opzione 1: Realfavicongenerator.net (Consigliato)
1. Vai su https://realfavicongenerator.net/
2. Carica il logo PrestaScan (usa l'emoji 🔍 o crea un logo PNG 512x512)
3. Scarica il pacchetto generato
4. Copia questi file nella root websitemacosps/:
   - favicon.ico
   - favicon-16x16.png
   - favicon-32x32.png
   - apple-touch-icon.png (180x180)

### Opzione 2: ImageMagick (CLI)
```bash
# Se hai un logo.png (512x512)
convert logo.png -resize 32x32 favicon-32x32.png
convert logo.png -resize 16x16 favicon-16x16.png
convert logo.png -resize 180x180 apple-touch-icon.png
convert logo.png -define icon:auto-resize=16,32,48 favicon.ico
```

### Opzione 3: Online Tool
- https://favicon.io/favicon-converter/
- https://www.favicon-generator.org/

## File necessari:
- ✅ site.webmanifest (già creato)
- ❌ favicon.ico
- ❌ favicon-16x16.png
- ❌ favicon-32x32.png
- ❌ apple-touch-icon.png

Una volta creati, il punteggio SEO sarà **95/100**!
