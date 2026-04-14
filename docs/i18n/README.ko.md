# CloaudeCodeCTO

> **언어:** [English](../../README.md) · [Türkçe](../../README.tr.md) · [Deutsch](README.de.md) · [Español](README.es.md) · [Français](README.fr.md) · [日本語](README.ja.md) · **한국어** · [中文](README.zh-CN.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

> Claude Code를 전체 라이프사이클 CTO로 전환: 14개 최고 오픈소스 저장소에서 엄선된 2,388개의 스킬, 에이전트, 커맨드를 외부 비용 없이 `~/.claude/`에 설치합니다.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-2388-green.svg)](../../decisions/selected.json)

---

## 이것은 무엇인가요?

CloaudeCodeCTO는 14개 공개 Claude Code 저장소에서 최고의 스킬, 에이전트, 커맨드를 가져와 하나의 일관된 툴킷으로 `~/.claude/` 디렉토리에 설치하는 **큐레이션 및 설치 시스템**입니다.

결과: 아이디어에서 프로덕션까지 안내해주는 Claude Code 설치 — Discovery, Planning, Design, Build, Test, 문서화, Shipping, 유지보수를 통해, 각 단계마다 목적에 맞는 에이전트를 사용합니다.

프로젝트를 위해 CTO를 고용하는 것으로 생각하세요: 모든 프레임워크, 모든 테스트 전략, 모든 배포 패턴을 이미 알고 있으며 각 단계에서 어떤 전문가를 호출해야 하는지 정확히 아는 사람입니다.

---

## 빠른 시작 — 한 개의 명령어

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

또는 `wget`으로:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

기본 타겟 디렉토리는 `$HOME/CloaudeCodeCTO`입니다. 변경하려면:

```bash
CCCTO_DIR=/custom/path bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### 수동 시작

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### 환경 변수

| 변수 | 기본값 | 설명 |
|---|---|---|
| `CCCTO_DIR` | `$HOME/CloaudeCodeCTO` | 타겟 클론 디렉토리 |
| `CCCTO_BRANCH` | `main` | 클론할 브랜치 |
| `CCCTO_AUTO` | `0` | `1` = 비대화형 모드 |
| `CCCTO_NO_INSTALL` | `0` | `1` = `~/.claude/` 설치 건너뛰기 |

---

## 기능

- **2,388 컴포넌트** — 14개 저장소에서 큐레이션된 1,845 스킬 + 307 에이전트 + 236 커맨드
- **8단계 라이프사이클** — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **외부 비용 없음** — Anthropic API 호출 없음, 유료 서비스 없음, 텔레메트리 없음
- **팩토리 리셋 호환** — 깨끗한 `~/.claude/`에서 작동, `.credentials.json` 보존
- **백업이 있는 원자적 설치** — 모든 것이 먼저 `/c/tmp/`에 스테이징된 후 커밋
- **기본적으로 대화형** — 모든 파괴적 작업을 확인, CI에는 `--auto`
- **재개 가능** — 파이프라인 단계는 `decisions/`에 쓰고, 모든 체크포인트에서 재시작 가능
- **단일 진실 소스** — `decisions/`만 권위 있음, 숨겨진 설정 없음
- **Windows + Linux + macOS** — 경로 인식 (Windows에서 `cygpath` 사용)

---

## 설치되는 것

```
~/.claude/
├── .credentials.json              (유지됨)
├── CLAUDE.md                      글로벌 지침 (생성됨)
├── settings.json                  하네스 설정 (생성됨)
├── skills/                        1,845 스킬
│   └── project-lifecycle/         메타 오케스트레이터 (8단계)
├── agents/                        307 전문 에이전트
├── commands/                      236 슬래시 커맨드
│   └── start-project.md           /start-project 라이프사이클 진입점
├── rules/
│   └── agent-decision-tree.md     어떤 작업에 어떤 에이전트
└── config/
    └── lifecycle.json             8단계 프로젝트 맵
```

**도메인별 분류:**

| 도메인 | 개수 | 예시 |
|---|---:|---|
| devops | 541 | docker, kubernetes, terraform, CI/CD |
| project-mgmt | 349 | 계획, OKR, 스프린트 워크플로우 |
| frontend | 333 | React, Vue, Next.js, 디자인 시스템 |
| coding | 287 | 언어별 빌더와 리뷰어 |
| backend | 183 | API, 데이터베이스, 마이크로서비스 |
| security | 143 | 감사, 침투 테스트, 컴플라이언스 |
| testing | 140 | 유닛, 통합, E2E, 뮤테이션 |
| data-ai | 132 | ML 파이프라인, LLM 통합, RAG |
| docs | 120 | 기술 문서, API 참조 |
| architecture | 81 | C4 다이어그램, ADR, 시스템 설계 |
| other | 79 | 기타 |

변경 전에 이전 `~/.claude/`의 백업이 자동으로 `/c/tmp/claude-install-backup-<timestamp>/`에 저장됩니다.

---

## 8단계 프로젝트 라이프사이클

설치 후 새로운 Claude Code 세션에서 `/start-project`를 실행하면 라이프사이클 오케스트레이터가 활성화됩니다.

| 단계 | 이름 | 모토 | 주요 에이전트 |
|---|---|---|---|
| 1 | Discovery | "무엇을, 왜?" | business-analyst, market-researcher, ux-researcher |
| 2 | Planning | "어떻게 만들까?" | planner, architect, product-manager |
| 3 | Design | "어떻게 보일까?" | ui-designer, api-designer, database-architect |
| 4 | Build | "코드 작성" | fullstack/frontend/backend-developer, tdd-guide |
| 5 | Test | "작동하는가?" | test-automator, qa-expert, e2e-runner |
| 6 | Document | "어떻게 사용할까?" | technical-writer, api-documenter |
| 7 | Ship | "프로덕션에 어떻게 올릴까?" | deployment-engineer, devops-engineer, sre-engineer |
| 8 | Maintain | "어떻게 건강하게 유지할까?" | performance-engineer, security-engineer, refactor-cleaner |

각 단계는 재개 가능합니다. 세션을 닫으면 `decisions/project-state.json`이 어디에 있었는지 기억합니다.

---

## 큐레이션 파이프라인

9단계 파이프라인이 `decisions/selected.json`을 빌드합니다. 유지 관리자의 머신에서만 실행되며 최종 사용자는 볼 수 없습니다.

```
1. DISCOVER     원시 컴포넌트의 TSV 인벤토리
2. EXTRACT      풍부한 메타데이터가 있는 catalog.json
3a. SCORE       100점 결정론적 루브릭
3b. SELF-SCORE  Claude Code 서브에이전트를 통한 시맨틱 스코어링
4. CURATE       중복 제거 + 도메인 그룹화 → selected.json
4.5 ORCHESTRATE 8단계 라이프사이클 바인딩
4.6 BUDGET      토큰 비용 프로필 (~105K 시작 시)
4.7 VALIDATE    22개 오버랩 쌍 → 결정 트리
5. INSTALL      원자적 스테이징 설치 + 백업
5.5 SMOKE TEST  8개 테스트 구조 검증
6. OPTIMIZE     사용 기반 프루닝 (선택적)
```

### 100점 루브릭

| 차원 | 점수 | 측정 내용 |
|---|---:|---|
| 구조적 | 30 | 유효한 YAML 프론트매터, 필수 필드, 크기 적정성 |
| 내용 | 30 | 설명 길이, 예시, 명확한 트리거 조건 |
| 크로스 저장소 | 20 | 저장소 간 고유성, 신선도 |
| 도메인 적합성 | 20 | 우선 도메인 보너스 |

---

## 소스 저장소

14개의 활성 서브모듈. 모든 라이선스는 각자의 디렉토리에 보존됩니다.

| 저장소 | 초점 | Skills | Agents | Commands |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | 공식 Anthropic 스킬 | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | 올인원 툴킷 | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | 대규모 스킬 컬렉션 | 1,404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | 도메인 전문가 | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | 큐레이션된 서브에이전트 | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | 풀 툴킷 | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | 지속적 개발 워크플로우 | 156 | 32 | 0 |

전체 목록은 [`.gitmodules`](../../.gitmodules)에 있습니다.

---

## 요구사항

- **Claude Code**가 `~/.claude/.credentials.json`에 자격 증명과 함께 설치됨
- **Python 3.8+**와 `PyYAML` (`install.sh`에 의해 자동 설치)
- **Bash** 4+ (Windows에서는 git-bash)
- **Git**과 서브모듈 지원
- **~1 GB 여유 디스크** 서브모듈 + 생성된 아티팩트용
- **~5–15분** 초기 설정

지원 플랫폼: Windows (git-bash), macOS, Linux.

---

## 제거

```bash
cd CloaudeCodeCTO
bash scripts/uninstall.sh --dry-run   # 제거될 항목 미리 보기
bash scripts/uninstall.sh             # 실제로 제거
```

제거 스크립트는 `decisions/install.tsv`를 읽고 CloaudeCodeCTO가 설치한 것**만** 삭제합니다.

**보호됨 — 절대 건드리지 않음:** `~/.claude/.credentials.json` (Claude Code 로그인), `~/.claude/projects/` (프로젝트별 메모리), 직접 추가한 컴포넌트, 편집한 `CLAUDE.md`/`settings.json`.

플래그: `--dry-run`, `--yes`/`-y`, `--keep-generated`.

---

## 문제 해결

### 셋업이 "Environment Check"에서 실패

```bash
pip install pyyaml
```

### 서브모듈 풀 실패

```bash
git submodule sync
git submodule update --init --recursive --force
```

### 설치가 중간에 실패

백업은 `/c/tmp/claude-install-backup-<timestamp>/`에 있습니다. 복원하려면:

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code가 새 스킬을 보지 못함

**새로운 Claude Code 세션**을 시작하세요. 시스템 프롬프트는 세션 시작 시 고정됩니다.

---

## FAQ

**Q: 왜 "비용 제로"인가요? Claude Code가 내 API 크레딧을 사용하잖아요?**
네 — Claude Code는 기존 세션을 사용합니다. "비용 제로"는 이 파이프라인을 의미합니다: 별도의 Anthropic API 키 없음, 타사 서비스 없음, 유료 스코어링 없음.

**Q: 기존 `~/.claude/`를 덮어쓰나요?**
아니요 — 인스톨러는 먼저 모든 것을 `/c/tmp/claude-install-backup-<timestamp>/`에 백업하고, 새 설치를 `/c/tmp/claude-install-stage-<timestamp>/`에 스테이징한 다음 파일을 복사합니다. 문제가 발생하면 백업 디렉토리에서 복원할 수 있습니다.

**Q: 설치할 컴포넌트를 선택할 수 있나요?**
네 — `setup.sh`를 실행하기 전에 `decisions/selected.json`을 편집하세요.

**Q: 1,845개 스킬을 로드하는 토큰 비용은?**
세션 시작 시 약 **105K 토큰**. 대부분의 스킬은 트리거될 때 지연 로드됩니다.

---

## 라이선스

MIT — [LICENSE](../../LICENSE) 참조.

## 감사의 말

이 프로젝트는 14개의 오픈소스 저장소에서 콘텐츠를 큐레이션합니다. 전체 목록은 [`.gitmodules`](../../.gitmodules)을 참조하세요. 모든 서브모듈 라이선스는 각자의 `sources/<repo>/` 디렉토리에 보존됩니다.

[@isatuncer](https://github.com/isatuncer)가 만들었습니다. PR과 이슈 환영합니다.
