# CloaudeCodeCTO

> **Idioma:** [English](../../README.md) · [Türkçe](../../README.tr.md) · [Deutsch](README.de.md) · **Español** · [Français](README.fr.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

> Convierte Claude Code en un CTO de ciclo de vida completo: 2.388 skills, agents y commands seleccionados a mano de 14 repositorios open-source líderes, instalados en `~/.claude/` con cero costo externo.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-2388-green.svg)](../../decisions/selected.json)

---

## ¿Qué es esto?

CloaudeCodeCTO es un **sistema de curación e instalación** que toma los mejores skills, agents y commands de 14 repositorios públicos de Claude Code y los instala en tu directorio `~/.claude/` como un kit de herramientas unificado.

El resultado: una instalación de Claude Code que puede guiarte **de la idea a producción** — a través de discovery, planning, design, build, test, documentación, shipping y mantenimiento — usando agents especializados en cada fase.

Piénsalo como contratar un CTO para tu proyecto: uno que ya conoce cada framework, cada estrategia de testing, cada patrón de deployment, y sabe exactamente qué especialista llamar en cada paso.

---

## Inicio Rápido — Un Comando

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

O con `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

El directorio destino por defecto es `$HOME/CloaudeCodeCTO`. Para cambiar:

```bash
CCCTO_DIR=/ruta/personalizada bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### Inicio Manual

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### Variables de Entorno

| Variable | Por defecto | Descripción |
|---|---|---|
| `CCCTO_DIR` | `$HOME/CloaudeCodeCTO` | Directorio de clonación destino |
| `CCCTO_BRANCH` | `main` | Rama a clonar |
| `CCCTO_AUTO` | `0` | `1` = modo no interactivo |
| `CCCTO_NO_INSTALL` | `0` | `1` = omitir instalación en `~/.claude/` |

---

## Características

- **2.388 componentes** — 1.845 skills + 307 agents + 236 commands, curados de 14 repos
- **Ciclo de vida de 8 fases** — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **Cero costo externo** — sin llamadas a la API de Anthropic, sin servicios pagados, sin telemetría
- **Compatible con factory-reset** — funciona en un `~/.claude/` limpio, preserva `.credentials.json`
- **Instalación atómica con backup** — todo staged en `/c/tmp/` primero, luego commit
- **Interactivo por defecto** — confirma cada acción destructiva; `--auto` para CI
- **Reanudable** — las etapas del pipeline escriben en `decisions/`, pueden reiniciar desde cualquier checkpoint
- **Fuente única de verdad** — solo `decisions/` es autoritativo; sin configuración oculta
- **Windows + Linux + macOS** — consciente de rutas (usa `cygpath` en Windows)

---

## Qué se Instala

```
~/.claude/
├── .credentials.json              (preservado)
├── CLAUDE.md                      instrucciones globales (generado)
├── settings.json                  config de harness (generado)
├── skills/                        1.845 skills
│   └── project-lifecycle/         meta-orchestrator (8 fases)
├── agents/                        307 agents especializados
├── commands/                      236 slash commands
│   └── start-project.md           entrada /start-project al ciclo de vida
├── rules/
│   └── agent-decision-tree.md     qué agent para qué tarea
└── config/
    └── lifecycle.json             mapa del proyecto de 8 fases
```

**Desglose por dominio:**

| Dominio | Cantidad | Ejemplos |
|---|---:|---|
| devops | 541 | docker, kubernetes, terraform, CI/CD |
| project-mgmt | 349 | planning, OKRs, flujos de sprint |
| frontend | 333 | React, Vue, Next.js, design systems |
| coding | 287 | builders y reviewers específicos por lenguaje |
| backend | 183 | APIs, bases de datos, microservicios |
| security | 143 | auditoría, pen-testing, compliance |
| testing | 140 | unit, integration, E2E, mutation |
| data-ai | 132 | pipelines ML, integración LLM, RAG |
| docs | 120 | escritura técnica, referencia API |
| architecture | 81 | diagramas C4, ADRs, diseño de sistemas |
| other | 79 | miscelánea |

Se guarda automáticamente un backup del `~/.claude/` anterior en `/c/tmp/claude-install-backup-<timestamp>/` antes de cualquier cambio.

---

## Ciclo de Vida del Proyecto de 8 Fases

Una vez instalado, ejecutar `/start-project` en una sesión nueva de Claude Code activa el orquestador del ciclo de vida.

| Fase | Nombre | Lema | Agents principales |
|---|---|---|---|
| 1 | Discovery | "¿Qué y por qué?" | business-analyst, market-researcher, ux-researcher |
| 2 | Planning | "¿Cómo lo construimos?" | planner, architect, product-manager |
| 3 | Design | "¿Cómo se verá?" | ui-designer, api-designer, database-architect |
| 4 | Build | "Escribir código" | fullstack/frontend/backend-developer, tdd-guide |
| 5 | Test | "¿Funciona?" | test-automator, qa-expert, e2e-runner |
| 6 | Document | "¿Cómo se usa?" | technical-writer, api-documenter |
| 7 | Ship | "¿Cómo va a producción?" | deployment-engineer, devops-engineer, sre-engineer |
| 8 | Maintain | "¿Cómo se mantiene sano?" | performance-engineer, security-engineer, refactor-cleaner |

Cada fase es reanudable. Si cierras la sesión, `decisions/project-state.json` recuerda dónde estabas.

---

## Pipeline de Curación

El pipeline de 9 etapas construye `decisions/selected.json`. Solo corre en la máquina del maintainer — los usuarios finales nunca lo ven.

```
1. DISCOVER     inventario TSV de componentes crudos
2. EXTRACT      catalog.json con metadata rica
3a. SCORE       rúbrica determinista de 100 puntos
3b. SELF-SCORE  scoring semántico vía subagents de Claude Code
4. CURATE       dedupe + agrupación por dominio → selected.json
4.5 ORCHESTRATE vinculación al ciclo de vida de 8 fases
4.6 BUDGET      perfil de costo de tokens (~105K al arranque)
4.7 VALIDATE    22 pares de overlap → árbol de decisión
5. INSTALL      instalación atómica staged + backup
5.5 SMOKE TEST  verificación estructural de 8 pruebas
6. OPTIMIZE     poda basada en uso (opcional)
```

### Desglose de la Rúbrica de 100 Puntos

| Dimensión | Puntos | Qué mide |
|---|---:|---|
| Estructural | 30 | YAML frontmatter válido, campos requeridos, tamaño razonable |
| Contenido | 30 | Longitud de descripción, ejemplos, condiciones de trigger claras |
| Cross-Repo | 20 | Unicidad entre repos; frescura |
| Ajuste de Dominio | 20 | Bonus por dominio prioritario |

---

## Repositorios Fuente

14 submódulos activos. Todas las licencias se preservan en sus respectivos directorios.

| Repositorio | Enfoque | Skills | Agents | Commands |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | Skills oficiales Anthropic | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | Toolkit todo-en-uno | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | Colección masiva de skills | 1.404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | Especialistas de dominio | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | Subagents curados | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | Toolkit completo | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | Workflow de dev continuo | 156 | 32 | 0 |

Lista completa en [`.gitmodules`](../../.gitmodules).

---

## Requisitos

- **Claude Code** instalado con credenciales en `~/.claude/.credentials.json`
- **Python 3.8+** con `PyYAML` (instalado automáticamente por `install.sh`)
- **Bash** 4+ (git-bash en Windows)
- **Git** con soporte de submódulos
- **~1 GB libre en disco** para submódulos + artefactos generados
- **~5–15 min** de setup inicial

Plataformas soportadas: Windows (git-bash), macOS, Linux.

---

## Desinstalación

```bash
cd CloaudeCodeCTO
bash scripts/uninstall.sh --dry-run   # vista previa de lo que se eliminaría
bash scripts/uninstall.sh             # eliminar realmente
```

El desinstalador lee `decisions/install.tsv` y elimina **solo** lo que CloaudeCodeCTO instaló.

**Protegido — nunca se toca:** `~/.claude/.credentials.json` (tu login de Claude Code), `~/.claude/projects/` (memoria por proyecto), componentes que agregaste tú y `CLAUDE.md`/`settings.json` si los editaste.

Flags: `--dry-run`, `--yes`/`-y`, `--keep-generated`.

---

## Resolución de Problemas

### Setup falla en "Environment Check"

```bash
pip install pyyaml
```

### Falla el pull de submódulos

```bash
git submodule sync
git submodule update --init --recursive --force
```

### Instalación falla a mitad

El backup está en `/c/tmp/claude-install-backup-<timestamp>/`. Restaurar con:

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code no ve los nuevos skills

Inicia una **sesión fresca de Claude Code**. El system prompt se congela al inicio de sesión.

---

## FAQ

**P: ¿Por qué es "cero costo"? Claude Code usa mis créditos de API, ¿verdad?**
Sí — Claude Code usa tu sesión existente. Lo que es "cero costo" es este pipeline: sin API keys separadas de Anthropic, sin servicios de terceros, sin scoring pagado.

**P: ¿Sobrescribirá mi `~/.claude/` existente?**
No — el installer primero respalda todo en `/c/tmp/claude-install-backup-<timestamp>/`, luego stagea la nueva instalación en `/c/tmp/claude-install-stage-<timestamp>/`, luego copia archivos. Si algo sale mal, puedes restaurar desde el directorio de backup.

**P: ¿Puedo elegir qué componentes instalar?**
Sí — edita `decisions/selected.json` antes de ejecutar `setup.sh`.

**P: ¿Cuál es el costo en tokens de cargar 1.845 skills?**
Aproximadamente **105K tokens** al inicio de sesión. La mayoría de skills se cargan lazy cuando se activan.

---

## Licencia

MIT — ver [LICENSE](../../LICENSE).

## Reconocimientos

Este proyecto cura contenido de 14 repositorios open-source. Ver [`.gitmodules`](../../.gitmodules) para la lista completa. Todas las licencias de submódulos se preservan en sus directorios `sources/<repo>/`.

Construido por [@isatuncer](https://github.com/isatuncer). PRs e issues son bienvenidos.
