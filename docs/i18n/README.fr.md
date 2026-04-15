# ClaudeCodeCTO

> **Langue:** [English](../../README.md) · [Türkçe](../../README.tr.md) · [Deutsch](README.de.md) · [Español](README.es.md) · **Français** · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

> Transformez Claude Code en un CTO à cycle de vie complet : 3.025 skills, agents et commandes sélectionnés à la main depuis 17 dépôts open-source de premier plan, installés dans `~/.claude/` sans aucun coût externe.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-3025-green.svg)](../../decisions/selected.json)

---

## Qu'est-ce que c'est ?

ClaudeCodeCTO est un **système de curation et d'installation** qui prend les meilleurs skills, agents et commandes de 17 dépôts Claude Code publics et les installe dans votre répertoire `~/.claude/` en tant que boîte à outils cohérente.

Le résultat : une installation Claude Code qui peut vous guider **de l'idée à la production** — à travers discovery, planning, design, build, test, documentation, shipping et maintenance — en utilisant des agents spécialisés à chaque phase.

Pensez-y comme embaucher un CTO pour votre projet : un qui connaît déjà chaque framework, chaque stratégie de test, chaque pattern de déploiement, et sait exactement quel spécialiste appeler à chaque étape.

---

## Démarrage Rapide — Une Commande

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Ou avec `wget` :

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Le répertoire cible par défaut est `$HOME/ClaudeCodeCTO`. Pour le remplacer :

```bash
CCCTO_DIR=/chemin/personnalise bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### Démarrage Manuel

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### Variables d'Environnement

| Variable | Défaut | Description |
|---|---|---|
| `CCCTO_DIR` | `$HOME/ClaudeCodeCTO` | Répertoire cible de clonage |
| `CCCTO_BRANCH` | `main` | Branche à cloner |
| `CCCTO_AUTO` | `0` | `1` = mode non interactif |
| `CCCTO_NO_INSTALL` | `0` | `1` = ignorer l'installation dans `~/.claude/` |

---

## Fonctionnalités

- **3.025 composants** — 2.044 skills + 550 agents + 236 commandes, curés de 17 dépôts
- **Cycle de vie en 8 phases** — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **Aucun coût externe** — pas d'appels API Anthropic, pas de services payants, pas de télémétrie
- **Compatible factory-reset** — fonctionne sur un `~/.claude/` propre, préserve `.credentials.json`
- **Installation atomique avec backup** — tout d'abord staged dans `/c/tmp/`, puis commit
- **Interactif par défaut** — confirme chaque action destructive ; `--auto` pour CI
- **Reprenable** — les étapes du pipeline écrivent dans `decisions/`, peuvent redémarrer depuis n'importe quel checkpoint
- **Source unique de vérité** — seul `decisions/` est autoritatif ; pas de config cachée
- **Windows + Linux + macOS** — conscient des chemins (utilise `cygpath` sous Windows)

---

## Ce Qui Est Installé

```
~/.claude/
├── .credentials.json              (préservé)
├── CLAUDE.md                      instructions globales (généré)
├── settings.json                  config du harness (généré)
├── skills/                        2.044 skills
│   └── project-lifecycle/         méta-orchestrateur (8 phases)
├── agents/                        550 agents spécialisés
├── commands/                      236 commandes slash
│   └── start-project.md           entrée /start-project du cycle de vie
├── rules/
│   └── agent-decision-tree.md     quel agent pour quelle tâche
└── config/
    └── lifecycle.json             carte du projet en 8 phases
```

**Répartition par domaine :**

| Domaine | Nombre | Exemples |
|---|---:|---|
| devops | 541 | docker, kubernetes, terraform, CI/CD |
| project-mgmt | 349 | planning, OKRs, workflows de sprint |
| frontend | 333 | React, Vue, Next.js, design systems |
| coding | 287 | builders et reviewers spécifiques aux langages |
| backend | 183 | APIs, bases de données, microservices |
| security | 143 | audit, pen-testing, conformité |
| testing | 140 | unit, integration, E2E, mutation |
| data-ai | 132 | pipelines ML, intégration LLM, RAG |
| docs | 120 | rédaction technique, référence API |
| architecture | 81 | diagrammes C4, ADRs, conception système |
| other | 79 | divers |

Une sauvegarde du `~/.claude/` précédent est automatiquement enregistrée dans `/c/tmp/claude-install-backup-<timestamp>/` avant tout changement.

---

## Le Cycle de Vie du Projet en 8 Phases

Une fois installé, exécuter `/start-project` dans une nouvelle session Claude Code active l'orchestrateur du cycle de vie.

| Phase | Nom | Devise | Agents principaux |
|---|---|---|---|
| 1 | Discovery | "Quoi et pourquoi ?" | business-analyst, market-researcher, ux-researcher |
| 2 | Planning | "Comment le construire ?" | planner, architect, product-manager |
| 3 | Design | "À quoi ça ressemble ?" | ui-designer, api-designer, database-architect |
| 4 | Build | "Écrire le code" | fullstack/frontend/backend-developer, tdd-guide |
| 5 | Test | "Ça fonctionne ?" | test-automator, qa-expert, e2e-runner |
| 6 | Document | "Comment l'utiliser ?" | technical-writer, api-documenter |
| 7 | Ship | "Comment ça passe en prod ?" | deployment-engineer, devops-engineer, sre-engineer |
| 8 | Maintain | "Comment rester en bonne santé ?" | performance-engineer, security-engineer, refactor-cleaner |

Chaque phase est reprenable. Si vous fermez la session, `decisions/project-state.json` se souvient où vous étiez.

---

## Pipeline de Curation

Le pipeline en 9 étapes construit `decisions/selected.json`. Il ne tourne que sur la machine du mainteneur — les utilisateurs finaux ne le voient jamais.

```
1. DISCOVER     inventaire TSV des composants bruts
2. EXTRACT      catalog.json avec metadata riche
3a. SCORE       grille déterministe de 100 points
3b. SELF-SCORE  scoring sémantique via subagents Claude Code
4. CURATE       dedupe + regroupement par domaine → selected.json
4.5 ORCHESTRATE liaison au cycle de vie en 8 phases
4.6 BUDGET      profil de coût en tokens (~105K au démarrage)
4.7 VALIDATE    22 paires d'overlap → arbre de décision
5. INSTALL      installation atomique staged + backup
5.5 SMOKE TEST  vérification structurelle en 8 tests
6. OPTIMIZE     élagage basé sur l'usage (optionnel)
```

### Grille de 100 Points

| Dimension | Points | Ce qui est mesuré |
|---|---:|---|
| Structurel | 30 | YAML frontmatter valide, champs requis, taille raisonnable |
| Contenu | 30 | Longueur de description, exemples, conditions de déclenchement claires |
| Cross-Repo | 20 | Unicité entre dépôts ; fraîcheur |
| Adéquation au Domaine | 20 | Bonus pour domaine prioritaire |

---

## Dépôts Sources

17 sous-modules actifs. Toutes les licences sont préservées dans leurs répertoires respectifs.

| Dépôt | Focus | Skills | Agents | Commandes |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | Skills officiels Anthropic | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | Toolkit tout-en-un | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | Collection massive de skills | 1 404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | Spécialistes de domaine | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | Subagents curés | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | Toolkit complet | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | Workflow dev continu | 156 | 32 | 0 |

Liste complète dans [`.gitmodules`](../../.gitmodules).

---

## Prérequis

- **Claude Code** installé avec credentials dans `~/.claude/.credentials.json`
- **Python 3.8+** avec `PyYAML` (installé automatiquement par `install.sh`)
- **Bash** 4+ (git-bash sous Windows)
- **Git** avec support des sous-modules
- **~1 Go libre sur disque** pour sous-modules + artefacts générés
- **~5–15 min** pour le setup initial

Plateformes supportées : Windows (git-bash), macOS, Linux.

---

## Désinstallation

```bash
cd ClaudeCodeCTO
bash scripts/uninstall.sh --dry-run   # prévisualiser ce qui serait supprimé
bash scripts/uninstall.sh             # supprimer réellement
```

Le désinstalleur lit `decisions/install.tsv` et supprime **uniquement** ce que ClaudeCodeCTO a installé.

**Protégé — jamais touché :** `~/.claude/.credentials.json` (votre login Claude Code), `~/.claude/projects/` (mémoire par projet), les composants que vous avez ajoutés et `CLAUDE.md`/`settings.json` si vous les avez modifiés.

Flags : `--dry-run`, `--yes`/`-y`, `--keep-generated`.

---

## Dépannage

### Setup échoue à "Environment Check"

```bash
pip install pyyaml
```

### Échec du pull des sous-modules

```bash
git submodule sync
git submodule update --init --recursive --force
```

### Installation échoue en cours

Le backup est dans `/c/tmp/claude-install-backup-<timestamp>/`. Restaurer avec :

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code ne voit pas les nouveaux skills

Démarrez une **nouvelle session Claude Code**. Le system prompt est figé au début de la session.

---

## FAQ

**Q : Pourquoi "aucun coût" ? Claude Code utilise mes crédits API, non ?**
Oui — Claude Code utilise votre session existante. Ce qui est "aucun coût" c'est ce pipeline : pas de clés API Anthropic séparées, pas de services tiers, pas de scoring payant.

**Q : Est-ce que ça va écraser mon `~/.claude/` existant ?**
Non — l'installeur sauvegarde d'abord tout dans `/c/tmp/claude-install-backup-<timestamp>/`, puis stage la nouvelle install dans `/c/tmp/claude-install-stage-<timestamp>/`, puis copie les fichiers. En cas de problème, vous pouvez restaurer depuis le répertoire de backup.

**Q : Puis-je choisir quels composants installer ?**
Oui — éditez `decisions/selected.json` avant de lancer `setup.sh`.

**Q : Quel est le coût en tokens pour charger 2.044 skills ?**
Environ **105K tokens** au démarrage de session. La plupart des skills sont chargés lazily quand ils sont déclenchés.

---

## Licence

MIT — voir [LICENSE](../../LICENSE).

## Remerciements

Ce projet cure du contenu de 17 dépôts open-source. Voir [`.gitmodules`](../../.gitmodules) pour la liste complète. Toutes les licences des sous-modules sont préservées dans leurs répertoires `sources/<repo>/` respectifs.

Construit par [@isatuncer](https://github.com/isatuncer). PRs et issues bienvenus.
