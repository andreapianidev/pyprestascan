# 🤝 Contributing to PyPrestaScan

Grazie per l'interesse in PyPrestaScan! Questo documento guida i contributor su come contribuire efficacemente al progetto.

## 📋 Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Architecture](#architecture)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)

---

## 📜 Code of Conduct

PyPrestaScan adotta un codice di condotta che tutti i contributor devono rispettare:
- ✅ Essere rispettosi e inclusivi
- ✅ Accettare critiche costruttive
- ✅ Focalizzarsi su ciò che è meglio per la community
- ❌ Zero tolleranza per comportamenti inappropriati

---

## 🚀 Getting Started

### Prerequisites
```bash
# Python 3.8+
python --version

# Git
git --version
```

### Setup Development Environment
```bash
# 1. Fork il repository su GitHub
# 2. Clona il tuo fork
git clone https://github.com/YOUR_USERNAME/pyprestascan.git
cd pyprestascan

# 3. Aggiungi upstream remote
git remote add upstream https://github.com/andreapianidev/pyprestascan.git

# 4. Crea virtual environment
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate   # Windows

# 5. Installa dependencies development
pip install -e ".[dev,gui]"

# 6. Installa pre-commit hooks
pre-commit install
```

### Verifica Setup
```bash
# Run tests
pytest

# Run linter
flake8 pyprestascan/

# Run type checker
mypy pyprestascan/

# Run GUI
python -m pyprestascan.gui.main_window
```

---

## 🔄 Development Workflow

### Branch Strategy
```bash
# main: stable, production-ready
# develop: integration branch (future)
# feature/*: nuove funzionalità
# fix/*: bug fixes
# docs/*: solo documentazione
```

### Workflow Esempio
```bash
# 1. Sync con upstream
git checkout main
git pull upstream main

# 2. Crea feature branch
git checkout -b feature/prestashop-api-integration

# 3. Sviluppa e commit (vedi Commit Guidelines)
git add .
git commit -m "feat(api): add PrestaShop API client"

# 4. Push al tuo fork
git push origin feature/prestashop-api-integration

# 5. Crea Pull Request su GitHub
```

---

## 🏗️ Architecture

### Directory Structure
```
pyprestascan/
├── core/               # Core scanning engine
│   ├── crawler.py      # Async web crawler
│   ├── analyzer.py     # SEO rule engine
│   ├── parser.py       # HTML/data parsing
│   ├── storage.py      # SQLite database
│   ├── fixer.py        # Fix generation
│   └── exporters.py    # Export formats
│
├── ai/                 # AI integration (v1.1.0+)
│   ├── providers.py    # DeepSeek/GPT/Claude
│   └── __init__.py
│
├── integrations/       # External integrations (v1.2.0+)
│   ├── prestashop_api.py    # PrestaShop API client
│   ├── excel_exporter.py    # Excel reports
│   └── webhook_client.py
│
├── monitoring/         # Continuous monitoring (v1.3.0+)
│   ├── scheduler.py    # Scan scheduling
│   ├── alerts.py       # Alert system
│   └── comparison.py   # Scan comparison
│
├── analysis/           # Advanced analysis (v1.4.0+)
│   ├── competitor.py   # Competitor benchmarking
│   ├── performance.py  # Core Web Vitals
│   └── content_quality.py  # AI content analysis
│
├── gui/                # Qt/PySide6 GUI
│   ├── main_window.py  # Main window
│   ├── themes.py       # Theme management (v1.2.0+)
│   └── tabs/           # Tab widgets (future refactor)
│
└── utils/              # Utilities
    ├── encryption.py   # API key encryption
    └── helpers.py
```

### Key Design Patterns

#### 1. Dependency Injection
```python
# GOOD: Inject dependencies
class SEOFixer:
    def __init__(self, db: CrawlDatabase, ai_provider: Optional[AIProvider] = None):
        self.db = db
        self.ai_provider = ai_provider

# BAD: Hard-coded dependencies
class SEOFixer:
    def __init__(self):
        self.db = CrawlDatabase("hardcoded.db")  # ❌
```

#### 2. Async/Await Pattern
```python
# Tutti i metodi I/O devono essere async
async def fetch_url(self, url: str) -> str:
    async with self.session.get(url) as response:
        return await response.text()
```

#### 3. Factory Pattern
```python
# Per creare oggetti basati su configurazione
class AIProviderFactory:
    @staticmethod
    def create(provider_name: str, api_key: str) -> AIProvider:
        providers = {
            'deepseek': DeepSeekProvider,
            'openai': OpenAIProvider,
            'claude': ClaudeProvider
        }
        return providers[provider_name](api_key)
```

---

## 💻 Coding Standards

### Python Style Guide
- **PEP 8** compliance (verificato da `flake8`)
- **Type hints** obbligatori (verificato da `mypy`)
- **Docstrings** per tutte le funzioni pubbliche (Google style)

#### Esempio Completo
```python
from typing import List, Optional
from dataclasses import dataclass


@dataclass
class ScanResult:
    """Risultato di una scansione SEO.

    Attributes:
        url: URL scansionato
        score: Score SEO (0-100)
        issues: Lista di issue rilevati
        timestamp: Data/ora scansione
    """
    url: str
    score: float
    issues: List[str]
    timestamp: datetime


async def analyze_page(url: str, rules: Optional[List[str]] = None) -> ScanResult:
    """Analizza una pagina web per problemi SEO.

    Args:
        url: URL completo da analizzare (es: https://example.com)
        rules: Lista regole SEO da applicare. Se None, usa tutte.

    Returns:
        ScanResult con score e issues rilevati.

    Raises:
        ValueError: Se URL non è valido
        httpx.HTTPError: Se richiesta fallisce

    Example:
        >>> result = await analyze_page("https://example.com")
        >>> print(result.score)
        85.5
    """
    if not url.startswith(('http://', 'https://')):
        raise ValueError(f"URL non valido: {url}")

    # Implementation...
    return ScanResult(url=url, score=85.5, issues=[], timestamp=datetime.now())
```

### Naming Conventions
```python
# Classes: PascalCase
class PrestaShopAPIClient:
    pass

# Functions/variables: snake_case
def calculate_seo_score():
    user_name = "Andrea"

# Constants: UPPER_SNAKE_CASE
MAX_CONCURRENT_REQUESTS = 20
DEFAULT_TIMEOUT = 30

# Private methods: _leading_underscore
def _internal_helper():
    pass
```

### Error Handling
```python
# GOOD: Specific exceptions
try:
    result = await api_client.update_product(product_id, data)
except PrestaShopAPIError as e:
    logger.error(f"API error: {e}")
    raise
except httpx.HTTPError as e:
    logger.error(f"Network error: {e}")
    return None

# BAD: Bare except
try:
    ...
except:  # ❌ Mai usare bare except
    pass
```

---

## 🧪 Testing

### Test Structure
```
tests/
├── unit/               # Unit tests (funzioni singole)
│   ├── test_analyzer.py
│   ├── test_fixer.py
│   └── test_ai_providers.py
│
├── integration/        # Integration tests (moduli multipli)
│   ├── test_scan_workflow.py
│   └── test_excel_export.py
│
└── e2e/                # End-to-end tests (GUI)
    └── test_gui_workflow.py
```

### Writing Tests

#### Unit Test Example
```python
import pytest
from pyprestascan.core.analyzer import SEOAnalyzer

@pytest.fixture
def analyzer():
    return SEOAnalyzer(prestashop_mode=True)

async def test_missing_title_detection(analyzer):
    """Test che analyzer rilevi title mancante"""
    page_data = PageData(url="https://test.com", title=None)

    issues = await analyzer.analyze_page(page_data)

    assert any(issue.code == 'TITLE_MISSING' for issue in issues)
    assert issues[0].severity == 'CRITICAL'
```

#### Integration Test Example
```python
async def test_scan_and_export_workflow():
    """Test workflow completo: scan → export"""
    # Setup
    config = CrawlConfig(url="https://demo.prestashop.com", max_urls=10)
    scanner = SEOScanner(config)

    # Scan
    await scanner.run()

    # Export
    exporter = ExcelReportExporter(scanner.results)
    file_path = exporter.export("test_report.xlsx")

    # Verify
    assert file_path.exists()
    wb = openpyxl.load_workbook(file_path)
    assert "Executive Summary" in wb.sheetnames
```

### Running Tests
```bash
# Run all tests
pytest

# Run con coverage
pytest --cov=pyprestascan --cov-report=html

# Run solo unit tests
pytest tests/unit/

# Run specifico test
pytest tests/unit/test_analyzer.py::test_missing_title_detection

# Run con output verbose
pytest -v

# Run e stop al primo fallimento
pytest -x
```

### Test Coverage Goals
- **Unit tests**: >= 80% coverage
- **Integration tests**: Tutti i workflow principali
- **E2E tests**: Happy paths + edge cases critici

---

## 🔀 Pull Request Process

### Before Submitting
```bash
# 1. Run tests
pytest

# 2. Run linters
flake8 pyprestascan/
black pyprestascan/
mypy pyprestascan/

# 3. Update docs se necessario
# 4. Add entry in CHANGELOG.md
```

### PR Title Convention
Usa [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(api): add PrestaShop API integration
fix(gui): resolve dark mode toggle issue
docs(readme): update installation instructions
refactor(core): improve crawler performance
test(analyzer): add unit tests for SEO rules
chore(deps): update httpx to 0.26.0
```

### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to break)
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
[Add screenshots here]

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests pass locally
```

### Review Process
1. **Automated checks** (GitHub Actions):
   - Tests pass ✅
   - Linting pass ✅
   - Type checking pass ✅

2. **Code review**:
   - Almeno 1 approval richiesta
   - Reviewer verifica:
     - Codice quality
     - Test coverage
     - Documentation
     - Breaking changes

3. **Merge**:
   - Squash commits se necessario
   - Merge to `main` dopo approval

---

## 📝 Commit Guidelines

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: Nuova feature
- `fix`: Bug fix
- `docs`: Solo documentazione
- `style`: Formattazione (no logic change)
- `refactor`: Code refactoring
- `test`: Aggiunta/modifica tests
- `chore`: Build, deps, config

### Example
```
feat(api): add PrestaShop API client with authentication

Implementa client asincrono per API REST PrestaShop.
Include:
- Authentication con webservice key
- CRUD operations per products/categories
- Batch update support
- Error handling robusto

Closes #123
```

---

## 🐛 Reporting Bugs

### Bug Report Template
```markdown
**Describe the bug**
Clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- OS: [e.g., macOS 14.0]
- Python version: [e.g., 3.11]
- PyPrestaScan version: [e.g., 1.1.0]

**Additional context**
Any other context about the problem.
```

---

## 💡 Feature Requests

### Feature Request Template
```markdown
**Is your feature request related to a problem?**
Clear description of the problem.

**Describe the solution you'd like**
Clear description of what you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Additional context**
Any other context or screenshots.
```

---

## 📚 Resources

### Documentation
- [Python Official Docs](https://docs.python.org/3/)
- [PySide6 Docs](https://doc.qt.io/qtforpython/)
- [httpx Docs](https://www.python-httpx.org/)
- [pytest Docs](https://docs.pytest.org/)

### Tools
- [Black](https://black.readthedocs.io/) - Code formatter
- [Flake8](https://flake8.pycqa.org/) - Linter
- [mypy](https://mypy.readthedocs.io/) - Type checker
- [pre-commit](https://pre-commit.com/) - Git hooks

### Learning
- [Async Python](https://realpython.com/async-io-python/)
- [Qt for Python Tutorial](https://doc.qt.io/qtforpython/tutorials/index.html)
- [Clean Code Python](https://github.com/zedr/clean-code-python)

---

## 🙏 Recognition

Contributors vengono riconosciuti in:
- README.md (Contributors section)
- Release notes
- Project website (future)

Top contributors possono ricevere:
- Commit access al repository
- Co-maintainer status
- Merchandise (future)

---

## 📞 Communication

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Q&A, ideas, general chat
- **Email**: info@andreapiani.com (urgent only)

---

**Grazie per contribuire a PyPrestaScan!** 🚀

Your contributions make this project better for everyone.
