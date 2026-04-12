---
name: start-project
description: Start a new project and guide the user through all 8 phases from discovery to maintenance, choosing the right agents and skills at each step.
---

# /start-project — Proje Yaşam Döngüsü Orkestratörü

Kullanıcı bir proje başlatmak istediğinde bu komutu çalıştırır. Claude Code, kullanıcıyı 8 faz boyunca yönlendirir, her fazda uygun agent'ları ve skill'leri çağırır, fazlar arası handoff yapar ve ilerlemeyi takip eder.

## Başlangıç Protokolü

1. Kullanıcıya proje türünü sor: `web app | mobile app | CLI | library | SaaS | microservice | data pipeline`
2. `decisions/project-state.json` dosyasını kontrol et — var olan bir state varsa kaldığı yerden devam et
3. Yoksa yeni state oluştur ve **Phase 1 (Discovery)** ile başla
4. Her faz başında: fazı tanıt, kullanıcıya soracağın soruları göster, onay bekle
5. Faz içinde uygun agent'ları otomatik çağır (aşağıdaki haritaya göre)
6. Faz bittiğinde: çıktıları özetle, `project-state.json`'ı güncelle, sonraki faza geçmeyi sor

## Faz → Agent / Skill Haritası

### Phase 1 — Discovery _"Ne yapıyoruz ve neden?"_

**Giriş kriteri:** Project type identified
**Çıkış kriteri:** PRD and user stories written
**Tipik süre:** 1-3 sessions

**Agent'lar (öncelik sırasıyla):**
- `business-analyst` (voltagent-subagents, skor 79.0) [OK]
- `market-researcher` (voltagent-subagents, skor 71.0) [OK]
- `ux-researcher` (rohitg00-toolkit, skor 66.2) [OK]
- `product-manager` (voltagent-subagents, skor 75.0) [OK]

**Skill'ler:**
- `brainstorming` (antigravity-awesome-skills, skor 71.0) [OK]
- `circleci-automation` (antigravity-awesome-skills, skor 88.0) [ALT]
- `c4-context` (antigravity-awesome-skills, skor 88.0) [ALT]
- `market-research` (everything-claude-code, skor 78.0) [OK]

**Kullanıcıya sorulacaklar:**
- Bu proje hangi problemi çözüyor?
- Hedef kullanıcı kim?
- Başarı nasıl ölçülecek?
- Rakipler/alternatifler neler?

**Çıktılar:** docs/PRD.md, docs/user-stories.md, docs/personas.md

---

### Phase 2 — Planning _"Nasıl yapacağız?"_

**Giriş kriteri:** Discovery phase complete
**Çıkış kriteri:** Technical plan, milestones, risk register
**Tipik süre:** 1-2 sessions

**Agent'lar (öncelik sırasıyla):**
- `planner` (everything-claude-code, skor 87.0) [OK]
- `architect` (continuous-claude-v3, skor 92.0) [OK]
- `product-manager` (voltagent-subagents, skor 75.0) [OK]
- `cs-project-manager` (alirezarezvani-claude-skills, skor 93.0) [OK]

**Skill'ler:**
- `jira-expert` (alirezarezvani-claude-skills, skor 89.0) [ALT]
- `audit-skills` (antigravity-awesome-skills, skor 88.0) [ALT]
- `product-capability` (everything-claude-code, skor 91.0) [ALT]
- `social-media-analyzer` (alirezarezvani-claude-skills, skor 93.0) [ALT]

**Kullanıcıya sorulacaklar:**
- Hangi teknoloji stack'ini kullanacağız?
- Zaman çizelgesi ne olacak?
- Ekip boyutu nedir?
- Kritik bağımlılıklar neler?

**Çıktılar:** docs/PLAN.md, docs/ROADMAP.md, docs/risks.md

---

### Phase 3 — Design _"Neye benzeyecek?"_

**Giriş kriteri:** Planning phase complete
**Çıkış kriteri:** Wireframes, API spec, DB schema
**Tipik süre:** 2-3 sessions

**Agent'lar (öncelik sırasıyla):**
- `ui-designer` (voltagent-subagents, skor 87.0) [OK]
- `api-designer` (voltagent-subagents, skor 87.0) [OK]
- `database-administrator` (voltagent-subagents, skor 85.0) [ALT]
- `architect` (continuous-claude-v3, skor 92.0) [OK]

**Skill'ler:**
- `design-system` (everything-claude-code, skor 83.0) [OK]
- `api-design` (everything-claude-code, skor 91.0) [OK]
- `postgresql` (antigravity-awesome-skills, skor 92.0) [ALT]
- `c4-architecture-c4-architecture` (antigravity-awesome-skills, skor 83.0) [ALT]

**Kullanıcıya sorulacaklar:**
- Kullanıcı akışları nasıl olacak?
- Hangi API endpoint'leri gerekli?
- Veri modeli nasıl şekillenecek?

**Çıktılar:** docs/architecture.md, docs/api-spec.md, docs/db-schema.md

---

### Phase 4 — Build _"Kod yazma"_

**Giriş kriteri:** Design phase complete, tasks broken down
**Çıkış kriteri:** Features implemented and working
**Tipik süre:** Multiple sessions

**Agent'lar (öncelik sırasıyla):**
- `fullstack-developer` (voltagent-subagents, skor 77.0) [OK]
- `frontend-developer` (voltagent-subagents, skor 85.0) [OK]
- `backend-developer` (voltagent-subagents, skor 79.0) [OK]
- `tdd-guide` (everything-claude-code, skor 87.0) [OK]

**Skill'ler:**
- `tdd` (continuous-claude-v3, skor 94.0) [OK]
- `coding-standards` (everything-claude-code, skor 87.0) [OK]
- `clean-code` (antigravity-awesome-skills, skor 70.0) [OK]
- `refactor` (continuous-claude-v3, skor 94.0) [OK]

**Kullanıcıya sorulacaklar:**
- Hangi özellikten başlayalım?
- TDD mi direkt implementation mı?

**Çıktılar:** src/**, tests/**

---

### Phase 5 — Test _"Doğru mu çalışıyor?"_

**Giriş kriteri:** Build phase complete or feature-ready
**Çıkış kriteri:** Test suite passing, coverage >= 80%
**Tipik süre:** 1-2 sessions per feature

**Agent'lar (öncelik sırasıyla):**
- `test-automator` (voltagent-subagents, skor 85.0) [OK]
- `qa-expert` (voltagent-subagents, skor 85.0) [OK]
- `e2e-runner` (everything-claude-code, skor 81.2) [OK]
- `tdd-guide` (everything-claude-code, skor 87.0) [OK]

**Skill'ler:**
- `test` (continuous-claude-v3, skor 94.0) [ALT]
- `e2e-testing` (everything-claude-code, skor 83.4) [OK]
- `tdd-guide` (alirezarezvani-claude-skills, skor 93.0) [ALT]
- `testing-strategies` (rohitg00-toolkit, skor 84.0) [ALT]

**Çıktılar:** tests/**, docs/test-report.md

---

### Phase 6 — Document _"Nasıl kullanılır?"_

**Giriş kriteri:** Features tested
**Çıkış kriteri:** README, API docs, user guides written
**Tipik süre:** 

**Agent'lar (öncelik sırasıyla):**
- `technical-writer` (voltagent-subagents, skor 87.0) [OK]
- `api-documenter` (voltagent-subagents, skor 77.0) [OK]
- `doc-updater` (everything-claude-code, skor 87.0) [OK]

**Skill'ler:**
- `readme` (antigravity-awesome-skills, skor 88.8) [OK]
- `api-documentation` (antigravity-awesome-skills, skor 88.0) [OK]
- `article-writing` (everything-claude-code, skor 82.0) [ALT]
- `codex-review` (antigravity-awesome-skills, skor 92.0) [ALT]

**Çıktılar:** README.md, docs/api.md, docs/guide.md, CHANGELOG.md

---

### Phase 7 — Ship _"Canlıya nasıl çıkar?"_

**Giriş kriteri:** Docs complete
**Çıkış kriteri:** Production deployment active, monitoring in place
**Tipik süre:** 

**Agent'lar (öncelik sırasıyla):**
- `deployment-engineer` (voltagent-subagents, skor 91.0) [OK]
- `devops-engineer` (voltagent-subagents, skor 91.0) [OK]
- `sre-engineer` (voltagent-subagents, skor 84.2) [OK]
- `docker-expert` (voltagent-subagents, skor 85.0) [OK]

**Skill'ler:**
- `odoo-docker-deployment` (antigravity-awesome-skills, skor 92.0) [ALT]
- `healthcare-cdss-patterns` (everything-claude-code, skor 95.0) [ALT]
- `deployment-patterns` (everything-claude-code, skor 91.0) [OK]
- `cloud-devops` (antigravity-awesome-skills, skor 88.0) [ALT]

**Çıktılar:** .github/workflows/**, Dockerfile, docs/deployment.md

---

### Phase 8 — Maintain _"Nasıl sağlıklı kalır?"_

**Giriş kriteri:** Production deployed
**Çıkış kriteri:** Ongoing monitoring, dep updates, bug fixes
**Tipik süre:** 

**Agent'lar (öncelik sırasıyla):**
- `performance-engineer` (voltagent-subagents, skor 75.0) [OK]
- `security-engineer` (voltagent-subagents, skor 87.0) [OK]
- `refactor-cleaner` (everything-claude-code, skor 87.0) [OK]
- `database-optimizer` (voltagent-subagents, skor 87.0) [OK]

**Skill'ler:**
- `multi-agent-task-orchestrator` (antigravity-awesome-skills, skor 92.0) [ALT]
- `performance-profiling` (antigravity-awesome-skills, skor 72.0) [OK]
- `security-pen-testing` (alirezarezvani-claude-skills, skor 85.0) [ALT]
- `security-audit` (antigravity-awesome-skills, skor 88.0) [OK]

**Çıktılar:** docs/runbook.md, docs/post-mortems/**

---

## Handoff Kuralları

Her faz bittiğinde, sonraki faza aşağıdakileri aktar:

- `discovery` → `planning`: **PRD + user stories + personas**
- `planning` → `design`: **Plan + tech stack + risks**
- `design` → `build`: **Architecture + API spec + DB schema**
- `build` → `test`: **Feature-complete code**
- `test` → `document`: **Passing test suite + coverage report**
- `document` → `ship`: **Docs + deployment checklist**
- `ship` → `maintain`: **Production URLs + monitoring dashboards**

## State Takibi

`decisions/project-state.json` şeması:
```json
{
  "project_name": "...",
  "project_type": "web app|mobile|cli|lib|saas|...",
  "current_phase": "discovery|planning|...|maintain",
  "completed_phases": ["discovery"],
  "phase_outputs": {
    "discovery": ["docs/PRD.md", "docs/user-stories.md"]
  },
  "started_at": "ISO timestamp",
  "last_updated": "ISO timestamp"
}
```

## Önemli Notlar

- **Agent seçiminde tereddüt etme** — bu dosyada her faz için belirtilen agent'ları sırayla dene
- **Kullanıcıya her fazda onay sor** — otomatik bir sonraki faza atlama
- **State'i her değişiklikten sonra kaydet** — session kesilse bile kaldığı yerden devam edilebilsin
- **Alternatif işaretli [ALT] olanlar** — tercih edilen tam eşleşme değil, en yakın seçim
