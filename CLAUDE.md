# Claude Code - Note per lo Sviluppo

## Deployment su GitHub e PyPI

### Processo Automatico tramite GitHub Actions

Il progetto utilizza **GitHub Actions** con **Trusted Publishing** per il deployment automatico su PyPI.

### Come Fare il Deploy

1. **Build del package**
   ```bash
   rm -rf dist build *.egg-info
   python3.12 -m build
   ```

2. **Creare una GitHub Release**
   ```bash
   gh release create v1.X.X \
     dist/pyprestascan-1.X.X-py3-none-any.whl \
     dist/pyprestascan-1.X.X.tar.gz \
     --title "vX.X.X - Titolo Release" \
     --notes "Descrizione della release"
   ```

3. **GitHub Actions fa tutto automaticamente**
   - La creazione della release triggera il workflow `.github/workflows/publish.yml`
   - Il workflow builda e pubblica su PyPI usando Trusted Publishing
   - Nessuna credenziale necessaria (tutto gestito da GitHub)

4. **Verificare il deployment**
   ```bash
   # Controllare lo stato del workflow
   gh run list --workflow=publish.yml --limit 5

   # Verificare su PyPI (dopo ~30 secondi)
   pip index versions pyprestascan
   ```

### File Importante

- `.github/workflows/publish.yml` - Workflow per pubblicazione automatica su PyPI

### Note

- **NON** usare `twine upload` manualmente (non ci sono credenziali locali)
- **SEMPRE** creare una GitHub release per triggerare il deployment
- Il workflow usa Trusted Publishing (nessun token necessario)
- Verificare che la versione in `pyproject.toml` sia aggiornata prima del build

### Versioning

Seguire Semantic Versioning:
- **MAJOR**: cambiamenti incompatibili con API precedenti
- **MINOR**: nuove funzionalità backward-compatible
- **PATCH**: bug fix backward-compatible

Esempio: `1.5.0` → Report migliorato + Fix generator non-bloccante
