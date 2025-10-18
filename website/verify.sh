#!/bin/bash

# Script di verifica pre-deploy per PyPrestaScan
# Esegue tutti i controlli necessari prima della pubblicazione

echo "🔍 VERIFICA PRE-DEPLOY PYPRESTASCAN"
echo "===================================="
echo ""

ERRORS=0
WARNINGS=0

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Verifica domini
echo "1️⃣  Verificando domini..."
OLD_DOMAIN=$(grep -r "pyprestascan\.com" . --include="*.html" --include="*.xml" --include="*.txt" 2>/dev/null | wc -l)
if [ "$OLD_DOMAIN" -eq 0 ]; then
    echo -e "${GREEN}✅ Nessun riferimento al vecchio dominio pyprestascan.com${NC}"
else
    echo -e "${RED}❌ Trovati $OLD_DOMAIN riferimenti al vecchio dominio!${NC}"
    ERRORS=$((ERRORS + 1))
fi

# 2. Verifica path assoluti
echo "2️⃣  Verificando path assoluti..."
ABS_HREF=$(grep -rn 'href="/' . --include="*.html" | grep -v "https://" | grep -v "http://" | wc -l)
ABS_SRC=$(grep -rn 'src="/' . --include="*.html" | grep -v "https://" | grep -v "http://" | wc -l)
TOTAL_ABS=$((ABS_HREF + ABS_SRC))

if [ "$TOTAL_ABS" -eq 0 ]; then
    echo -e "${GREEN}✅ Nessun path assoluto trovato${NC}"
else
    echo -e "${RED}❌ Trovati $TOTAL_ABS path assoluti (href: $ABS_HREF, src: $ABS_SRC)${NC}"
    ERRORS=$((ERRORS + 1))
fi

# 3. Verifica file essenziali
echo "3️⃣  Verificando file essenziali..."
REQUIRED_FILES=("index.html" "sitemap.xml" "robots.txt" "blog/index.html")
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✅ $file${NC}"
    else
        echo -e "${RED}  ❌ $file MANCANTE!${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# 4. Verifica articoli blog
echo "4️⃣  Verificando articoli blog..."
ARTICLES=(
    "blog/guida-seo-prestashop-2025/index.html"
    "blog/prestashop-vs-woocommerce-seo/index.html"
    "blog/errori-seo-prestashop-comuni/index.html"
    "blog/generare-meta-description-ai/index.html"
    "blog/alternative-screaming-frog/index.html"
)

ARTICLES_OK=0
for article in "${ARTICLES[@]}"; do
    if [ -f "$article" ]; then
        ARTICLES_OK=$((ARTICLES_OK + 1))
    fi
done
echo -e "${GREEN}✅ $ARTICLES_OK/5 articoli presenti${NC}"

# 5. Verifica canonical URL
echo "5️⃣  Verificando canonical URL..."
CANONICAL_COUNT=$(grep -r "canonical" . --include="*.html" | grep "pyprestascan.andreapiani.com" | wc -l)
if [ "$CANONICAL_COUNT" -gt 5 ]; then
    echo -e "${GREEN}✅ Canonical URL configurati ($CANONICAL_COUNT trovati)${NC}"
else
    echo -e "${YELLOW}⚠️  Pochi canonical URL trovati ($CANONICAL_COUNT)${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# 6. Verifica immagini (warning, non errore)
echo "6️⃣  Verificando cartella immagini..."
if [ -d "images" ]; then
    IMG_COUNT=$(find images -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null | wc -l)
    if [ "$IMG_COUNT" -gt 0 ]; then
        echo -e "${GREEN}✅ Cartella images con $IMG_COUNT file${NC}"
    else
        echo -e "${YELLOW}⚠️  Cartella images vuota (opzionale)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${YELLOW}⚠️  Cartella images non trovata${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# 7. Verifica form newsletter
echo "7️⃣  Verificando form newsletter..."
FORMS_WITH_ACTION=$(grep -r "class=\"newsletter-form\"" . --include="*.html" -A 1 | grep "action=" | wc -l)
if [ "$FORMS_WITH_ACTION" -gt 0 ]; then
    echo -e "${GREEN}✅ Form newsletter con action configurati${NC}"
else
    echo -e "${YELLOW}⚠️  Form senza action${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# 8. Verifica sitemap
echo "8️⃣  Verificando sitemap.xml..."
if grep -q "pyprestascan.andreapiani.com" sitemap.xml 2>/dev/null; then
    URL_COUNT=$(grep -c "<loc>" sitemap.xml)
    echo -e "${GREEN}✅ Sitemap con dominio corretto ($URL_COUNT URL)${NC}"
else
    echo -e "${RED}❌ Sitemap non configurato correttamente!${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Report finale
echo ""
echo "===================================="
echo "📊 REPORT FINALE"
echo "===================================="
echo -e "Errori critici: ${RED}$ERRORS${NC}"
echo -e "Warning: ${YELLOW}$WARNINGS${NC}"
echo ""

if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}✅ SITO PRONTO PER IL DEPLOY!${NC}"
    echo ""
    echo "Puoi procedere con:"
    echo "  rsync -avz --delete ./ user@pyprestascan.andreapiani.com:/var/www/html/"
    exit 0
else
    echo -e "${RED}❌ ERRORI TROVATI - CORREGGI PRIMA DEL DEPLOY${NC}"
    exit 1
fi