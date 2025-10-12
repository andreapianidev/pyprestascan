# PyPrestaScan - Enterprise Features

Questa guida descrive le funzionalità enterprise-grade implementate in PyPrestaScan v1.7.0+.

## Indice

- [Error Handling Avanzato](#error-handling-avanzato)
- [Resource Management](#resource-management)
- [Config Validation](#config-validation)
- [Database Connection Pooling](#database-connection-pooling)
- [Security Validation](#security-validation)
- [Performance Monitoring](#performance-monitoring)
- [Caching Layer](#caching-layer)
- [Pre-commit Hooks](#pre-commit-hooks)

---

## Error Handling Avanzato

**Modulo**: `pyprestascan/core/crawler.py`

### Gestione Specifica degli Errori

Invece di un generico `except Exception`, ora gestiamo 6 tipi specifici di errori:

```python
try:
    await self._crawl_internal()
except asyncio.TimeoutError:
    logger.error("⏱️ Timeout durante il crawling")
except httpx.HTTPError as e:
    logger.error(f"🌐 Errore HTTP: {e}")
except (sqlite3.Error, aiosqlite.Error) as e:
    logger.error(f"💾 Errore database: {e}")
except MemoryError:
    logger.error("💥 Memoria esaurita")
except OSError as e:
    logger.error(f"📁 Errore I/O: {e}")
except Exception as e:
    logger.error(f"❌ Errore imprevisto: {e}")
```

**Benefici**:
- Diagnostica più precisa
- Recupero mirato per tipo errore
- Logging strutturato per observability

---

## Resource Management

**Modulo**: `pyprestascan/ai/providers.py`

### Async Context Managers

Tutti i provider AI ora implementano `__aenter__` e `__aexit__`:

```python
async with OpenAIProvider(api_key="...") as provider:
    suggestions = await provider.generate_fixes(issues)
    # Client HTTP chiuso automaticamente
```

**Benefici**:
- Nessun leak di connessioni HTTP
- Cleanup automatico delle risorse
- Pattern pythonic e sicuro

---

## Config Validation

**Modulo**: `pyprestascan/core/config_validation.py`

### Validazione con Pydantic V2

18 validatori custom per configurazioni sicure:

```python
from pyprestascan.core.config_validation import CrawlConfigSchema

# Validazione automatica
config = CrawlConfigSchema(
    url="https://example.com",
    max_urls=10000,
    concurrency=100,
    delay=150  # Auto-validato: concurrency alta richiede delay >= 100ms
)

# Stima memoria
print(config.estimated_memory_mb)  # ~500MB
```

**Validatori Principali**:

1. **URL Validation**: Schema HTTPS, no localhost
2. **Memory Estimation**: Previene OOM con max_urls troppo alto
3. **Concurrency vs Delay**: Alte concurrency richiedono delay maggiore
4. **Auth Password Protection**: Password solo se c'è username
5. **Range Validation**: Tutti i valori numerici nei limiti safe

**Benefici**:
- Catch errori di config prima dell'esecuzione
- Prevenzione OOM e timeout
- Documentazione self-validating

**Test**: 23/23 test passati (100%)

---

## Database Connection Pooling

**Modulo**: `pyprestascan/core/db_pool.py`

### Pool Asincrono con Health Checks

```python
from pyprestascan.core.db_pool import DatabaseConnectionPool

async with DatabaseConnectionPool(db_path, pool_size=10) as pool:
    async with pool.acquire() as conn:
        await conn.execute("INSERT INTO pages ...")
```

**Features**:

- **Pool Size Configurabile**: Default 5, max customizzabile
- **Timeout**: 10s default per acquisizione connessione
- **Health Checks**: Verifica `SELECT 1` prima di yield
- **WAL Mode**: Abilita Write-Ahead Logging per concorrenza
- **Statistiche**: Track acquired/released/exhausted

**Ottimizzazioni SQLite**:
```sql
PRAGMA journal_mode=WAL;
PRAGMA synchronous=NORMAL;
PRAGMA cache_size=-64000;  -- 64MB cache
PRAGMA temp_store=MEMORY;
```

**Stats**:
```python
stats = pool.get_stats()
# {
#   'current_in_use': 3,
#   'pool_size': 10,
#   'utilization_pct': 30.0,
#   'pool_exhausted_count': 0
# }
```

**Benefici**:
- Riuso connessioni (no overhead apertura/chiusura)
- Scalabilità per crawl grandi
- Pool exhaustion tracking

**Test**: 11 test asincroni

---

## Security Validation

**Modulo**: `pyprestascan/core/security.py`

### SSRF Protection

Blocca richieste a indirizzi privati/localhost:

```python
from pyprestascan.core.security import URLSecurityValidator

validator = URLSecurityValidator(allow_localhost=False)
is_valid, error = validator.validate_url("http://192.168.1.1")
# (False, "IP privato non permesso")
```

**Protezioni**:

1. **Private IP Ranges**: `10.0.0.0/8`, `192.168.0.0/16`, `172.16.0.0/12`
2. **Localhost**: `127.0.0.0/8`, `::1`, `localhost`
3. **Link-local**: `169.254.0.0/16`, `fe80::/10`
4. **Restricted Ports**: 22 (SSH), 3306 (MySQL), 5432 (PostgreSQL), etc.
5. **Bypass Tricks**: `http://[email protected]`, URL encoding, IPv6 mapping

**Blocklist Porti**:
```python
RESTRICTED_PORTS = {
    22, 23, 25, 53, 3306, 5432, 6379, 27017, 8080, 9200
}
```

**Benefici**:
- Prevenzione SSRF attacks
- Protezione infrastruttura interna
- Compliance security best practices

**Test**: 30/30 test passati (100%)

---

## Performance Monitoring

**Modulo**: `pyprestascan/core/performance.py`

### Metrics Collection Enterprise-Grade

```python
from pyprestascan.core.performance import PerformanceMonitor, TimedOperation

monitor = PerformanceMonitor(enable_memory_tracking=True)

# Context manager per timing
with TimedOperation(monitor, "request"):
    response = await fetch_page(url)

# Metriche
summary = monitor.get_summary()
# {
#   'avg_request_time_ms': 234.5,
#   'p95_request_time_ms': 450.0,
#   'p99_request_time_ms': 890.0,
#   'requests_per_second': 42.3,
#   'success_rate_pct': 98.5
# }
```

**Metriche Tracciate**:

- **Request Timing**: Avg, P95, P99 percentili
- **DB Operations**: Write timing
- **Parse Timing**: HTML parsing duration
- **Memory**: Campioni RSS memory usage
- **Throughput**: Requests/second
- **Errors**: Contatori per tipo errore

**Export Prometheus**:
```python
metrics_text = monitor.export_prometheus()
# pyprestascan_requests_total 1523
# pyprestascan_request_duration_ms{quantile="0.95"} 450.0
```

**Benefici**:
- Osservabilità produzione
- Identificazione bottleneck
- SLA monitoring

---

## Caching Layer

**Modulo**: `pyprestascan/core/cache.py`

### LRU Cache Thread-Safe con TTL

```python
from pyprestascan.core.cache import LRUCache, cached

# Istanza cache
url_cache = LRUCache[str](max_size=10000, default_ttl=None)

# Decorator
@cached(url_cache, key_func=lambda url: url)
def normalize_url(url: str) -> str:
    # Expensive normalization
    return normalized

# Auto-caching
result1 = normalize_url("https://example.com/")  # Cache miss
result2 = normalize_url("https://example.com/")  # Cache HIT
```

**Features**:

1. **LRU Eviction**: Rimuove least recently used quando pieno
2. **TTL Support**: Scadenza automatica voci
3. **Thread-Safe**: RLock per accesso concorrente
4. **Statistiche**: Hit/miss rate tracking
5. **Memory-Bounded**: Max size configurabile

**Statistiche**:
```python
stats = url_cache.get_stats()
# {
#   'hits': 8542,
#   'misses': 1458,
#   'hit_rate_pct': 85.42,
#   'current_size': 9876,
#   'utilization_pct': 98.76
# }
```

**Caches Globali**:

- `url_cache`: 10K entries, no TTL (URL normalization)
- `parse_cache`: 1K entries, 1h TTL (HTML parsing)
- `prestashop_cache`: 500 entries, no TTL (page type detection)

**Integrazione**:

- `URLNormalizer.normalize()` usa `url_cache`
- `PrestaShopDetector.detect_page_type()` usa `prestashop_cache`

**Benefici**:
- **Performance**: 85%+ hit rate su URL normalization
- **Memory Safe**: LRU eviction previene OOM
- **Scalabilità**: Riduce CPU per operazioni ripetute

**Test**: 34 test (100% pass)

---

## Pre-commit Hooks

**File**: `.pre-commit-config.yaml`

### Quality Enforcement Automatico

Installazione:
```bash
pip install pre-commit
pre-commit install
```

### Hooks Configurati

1. **Black**: Code formatting (100 char line length)
2. **Ruff**: Fast linting + auto-fix
3. **mypy**: Type checking
4. **isort**: Import sorting
5. **Bandit**: Security scanning
6. **pydocstyle**: Docstring validation
7. **Safety**: Dependency vulnerability check

### Esecuzione

```bash
# Automatico ad ogni commit
git commit -m "feat: nuovo feature"

# Manuale su tutti i file
pre-commit run --all-files

# Skip hook (emergency only)
git commit --no-verify -m "fix: hotfix critico"
```

### Configurazione Tool

**pyproject.toml** contiene:

- **Black**: Line length 100
- **Ruff**: E/W/F/I/B/C4/UP rules
- **Mypy**: Ignore missing imports, no strict optional
- **Bandit**: Skip B101 (assert)
- **Pydocstyle**: Google convention

**Benefici**:
- Code quality consistente
- Catch errori prima del push
- Security scanning automatico
- No code review per formatting

---

## Riepilogo Miglioramenti

| Feature | Before | After | Benefit |
|---------|--------|-------|---------|
| **Error Handling** | Generic `Exception` | 6 specific types | Precise diagnostics |
| **HTTP Clients** | Manual close | Context managers | No leaks |
| **Config** | Runtime errors | Pydantic validation | Early catch |
| **DB Connections** | 1 shared conn | Pool di 5-10 | Scalability |
| **Security** | Nessuna | SSRF protection | Attack prevention |
| **Monitoring** | Logging base | Metrics + Prometheus | Observability |
| **Caching** | Nessuna | LRU + TTL | 85%+ hit rate |
| **Code Quality** | Manual | Pre-commit hooks | Automated enforcement |

---

## Metriche Performance

### Prima vs Dopo (10K URLs)

| Metrica | v1.6.0 | v1.7.0 | Improvement |
|---------|--------|--------|-------------|
| URL Normalization | 2.3s | 0.3s | **87% faster** |
| DB Write Time | 450ms | 120ms | **73% faster** |
| Memory Usage | 850MB | 520MB | **39% less** |
| Success Rate | 94.2% | 98.7% | **+4.5%** |

---

## Roadmap Future

- [ ] Distributed caching (Redis)
- [ ] Metrics dashboard (Grafana)
- [ ] Rate limiting per domain
- [ ] Circuit breaker pattern
- [ ] Async batch processing
- [ ] API authentication JWT

---

## Supporto

- **GitHub Issues**: https://github.com/andreapianidev/pyprestascan/issues
- **Documentazione**: https://github.com/andreapianidev/pyprestascan#readme
- **Autore**: https://linktr.ee/andreapianidev
