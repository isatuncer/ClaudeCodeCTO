# CloaudeCodeCTO

> **Язык:** [English](../../README.md) · [Türkçe](../../README.tr.md) · [Deutsch](README.de.md) · [Español](README.es.md) · [Français](README.fr.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md) · **Русский** · [العربية](README.ar.md)

> Превратите Claude Code в CTO полного жизненного цикла: 2 388 тщательно отобранных навыков, агентов и команд из 15 лучших open-source репозиториев, устанавливаемых в `~/.claude/` без внешних затрат.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-2388-green.svg)](../../decisions/selected.json)

---

## Что это?

CloaudeCodeCTO — это **система курирования и установки**, которая берёт лучшие навыки, агенты и команды из 15 публичных репозиториев Claude Code и устанавливает их в ваш каталог `~/.claude/` как единый согласованный инструментарий.

Результат: установка Claude Code, которая может провести вас **от идеи до производства** — через Discovery, Planning, Design, Build, Test, документацию, Shipping и поддержку — используя специализированных агентов на каждом этапе.

Думайте об этом как о найме CTO для вашего проекта: того, кто уже знает каждый фреймворк, каждую стратегию тестирования, каждый паттерн деплоймента и точно знает, какого специалиста вызывать на каждом шаге.

---

## Быстрый старт — Одна команда

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Или с `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Целевой каталог по умолчанию — `$HOME/CloaudeCodeCTO`. Чтобы переопределить:

```bash
CCCTO_DIR=/custom/path bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### Ручной старт

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### Переменные окружения

| Переменная | По умолчанию | Описание |
|---|---|---|
| `CCCTO_DIR` | `$HOME/CloaudeCodeCTO` | Целевой каталог клонирования |
| `CCCTO_BRANCH` | `main` | Ветка для клонирования |
| `CCCTO_AUTO` | `0` | `1` = неинтерактивный режим |
| `CCCTO_NO_INSTALL` | `0` | `1` = пропустить установку в `~/.claude/` |

---

## Возможности

- **2 388 компонентов** — 1 845 навыков + 307 агентов + 236 команд, курированных из 15 репозиториев
- **Жизненный цикл из 8 фаз** — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **Никаких внешних затрат** — без вызовов Anthropic API, без платных сервисов, без телеметрии
- **Совместимость с factory-reset** — работает на чистом `~/.claude/`, сохраняет `.credentials.json`
- **Атомарная установка с резервным копированием** — всё сначала в `/c/tmp/`, затем коммит
- **Интерактивный по умолчанию** — подтверждает каждое разрушительное действие; `--auto` для CI
- **Возобновляемый** — этапы пайплайна пишут в `decisions/`, могут перезапускаться с любой контрольной точки
- **Единый источник истины** — только `decisions/` авторитетен; нет скрытой конфигурации
- **Windows + Linux + macOS** — учитывает пути (использует `cygpath` в Windows)

---

## Что устанавливается

```
~/.claude/
├── .credentials.json              (сохраняется)
├── CLAUDE.md                      глобальные инструкции (генерируется)
├── settings.json                  конфиг harness (генерируется)
├── skills/                        1 845 навыков
│   └── project-lifecycle/         мета-оркестратор (8 фаз)
├── agents/                        307 специализированных агентов
├── commands/                      236 слэш-команд
│   └── start-project.md           /start-project точка входа жизненного цикла
├── rules/
│   └── agent-decision-tree.md     какой агент для какой задачи
└── config/
    └── lifecycle.json             карта проекта из 8 фаз
```

**Разбивка по домену:**

| Домен | Количество | Примеры |
|---|---:|---|
| devops | 541 | docker, kubernetes, terraform, CI/CD |
| project-mgmt | 349 | планирование, OKR, спринт-воркфлоу |
| frontend | 333 | React, Vue, Next.js, дизайн-системы |
| coding | 287 | языко-специфичные билдеры и ревьюеры |
| backend | 183 | API, базы данных, микросервисы |
| security | 143 | аудит, пен-тестинг, комплаенс |
| testing | 140 | юнит, интеграция, E2E, мутационное |
| data-ai | 132 | ML-пайплайны, LLM-интеграция, RAG |
| docs | 120 | техническое письмо, API-справка |
| architecture | 81 | C4 диаграммы, ADR, системный дизайн |
| other | 79 | разное |

Резервная копия предыдущего `~/.claude/` автоматически сохраняется в `/c/tmp/claude-install-backup-<timestamp>/` перед любыми изменениями.

---

## Жизненный цикл проекта из 8 фаз

После установки запуск `/start-project` в новой сессии Claude Code активирует оркестратор жизненного цикла.

| Фаза | Имя | Девиз | Основные агенты |
|---|---|---|---|
| 1 | Discovery | "Что и почему?" | business-analyst, market-researcher, ux-researcher |
| 2 | Planning | "Как построить?" | planner, architect, product-manager |
| 3 | Design | "Как это выглядит?" | ui-designer, api-designer, database-architect |
| 4 | Build | "Писать код" | fullstack/frontend/backend-developer, tdd-guide |
| 5 | Test | "Работает ли?" | test-automator, qa-expert, e2e-runner |
| 6 | Document | "Как использовать?" | technical-writer, api-documenter |
| 7 | Ship | "Как выйти в прод?" | deployment-engineer, devops-engineer, sre-engineer |
| 8 | Maintain | "Как оставаться здоровым?" | performance-engineer, security-engineer, refactor-cleaner |

Каждая фаза возобновляема. Если вы закроете сессию, `decisions/project-state.json` запомнит, где вы были.

---

## Пайплайн курирования

9-стадийный пайплайн строит `decisions/selected.json`. Он запускается только на машине майнтейнера — конечные пользователи его никогда не видят.

```
1. DISCOVER     TSV-инвентарь сырых компонентов
2. EXTRACT      catalog.json с богатой метадатой
3a. SCORE       детерминированная рубрика на 100 очков
3b. SELF-SCORE  семантический скоринг через субагентов Claude Code
4. CURATE       дедупликация + группировка по доменам → selected.json
4.5 ORCHESTRATE привязка к 8-фазному жизненному циклу
4.6 BUDGET      профиль токен-затрат (~105K на старте)
4.7 VALIDATE    22 пары перекрытий → дерево решений
5. INSTALL      атомарная поэтапная установка + резервное копирование
5.5 SMOKE TEST  8-тестовая структурная верификация
6. OPTIMIZE     обрезка на основе использования (опционально)
```

### Рубрика на 100 очков

| Измерение | Очки | Что измеряется |
|---|---:|---|
| Структурное | 30 | Валидный YAML frontmatter, обязательные поля, разумный размер |
| Контент | 30 | Длина описания, примеры, чёткие условия триггера |
| Кросс-репо | 20 | Уникальность между репо, свежесть |
| Доменная пригодность | 20 | Бонус приоритетного домена |

---

## Исходные репозитории

15 активных сабмодулей. Все лицензии сохраняются в соответствующих каталогах.

| Репозиторий | Фокус | Skills | Agents | Commands |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | Официальные навыки Anthropic | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | Всё-в-одном инструментарий | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | Массивная коллекция навыков | 1 404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | Доменные специалисты | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | Курированные субагенты | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | Полный инструментарий | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | Continuous-dev воркфлоу | 156 | 32 | 0 |

Полный список в [`.gitmodules`](../../.gitmodules).

---

## Требования

- **Claude Code** установлен с учётными данными в `~/.claude/.credentials.json`
- **Python 3.8+** с `PyYAML` (автоматически устанавливается `install.sh`)
- **Bash** 4+ (git-bash в Windows)
- **Git** с поддержкой сабмодулей
- **~1 ГБ свободного места** для сабмодулей + генерируемых артефактов
- **~5–15 мин** первоначальной настройки

Поддерживаемые платформы: Windows (git-bash), macOS, Linux.

---

## Устранение неполадок

### Setup падает на "Environment Check"

```bash
pip install pyyaml
```

### Сабмодульный pull не удаётся

```bash
git submodule sync
git submodule update --init --recursive --force
```

### Установка падает на полпути

Резервная копия в `/c/tmp/claude-install-backup-<timestamp>/`. Восстановить:

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code не видит новые навыки

Запустите **свежую сессию Claude Code**. Системный промпт замораживается в начале сессии.

---

## FAQ

**В: Почему это "бесплатно"? Claude Code использует мои API-кредиты, верно?**
Да — Claude Code использует вашу существующую сессию. "Ноль затрат" относится к этому пайплайну: нет отдельных API-ключей Anthropic, нет сторонних сервисов, нет платного скоринга.

**В: Это перезапишет мой существующий `~/.claude/`?**
Нет — инсталлер сначала резервирует всё в `/c/tmp/claude-install-backup-<timestamp>/`, затем подготавливает новую установку в `/c/tmp/claude-install-stage-<timestamp>/`, затем копирует файлы. Если что-то пойдёт не так, вы можете восстановить из каталога резервной копии.

**В: Могу ли я выбрать, какие компоненты устанавливать?**
Да — отредактируйте `decisions/selected.json` перед запуском `setup.sh`.

**В: Какова стоимость в токенах загрузки 1 845 навыков?**
Около **105K токенов** при старте сессии. Большинство навыков загружаются лениво при срабатывании.

---

## Лицензия

MIT — см. [LICENSE](../../LICENSE).

## Благодарности

Этот проект курирует контент из 15 open-source репозиториев. Полный список см. в [`.gitmodules`](../../.gitmodules). Все лицензии сабмодулей сохраняются в их соответствующих каталогах `sources/<repo>/`.

Создано [@isatuncer](https://github.com/isatuncer). PR и issue приветствуются.
