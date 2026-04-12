# CloaudeCodeCTO — Master Plan

> **Amaç:** `sources/` dizinindeki submodule repo'lardan (16 repo, 1500+ skill, 300+ agent, 100+ command) en iyilerini seçip `~/.claude/` altına kurarak Claude Code'u şu konularda mükemmelleştirmek:
> - Proje yönetimi (baştan sonra proje oluşturma, yönlendirme)
> - Dokümantasyon
> - Test yazma
> - Kod yazma & mimari
> - Token optimizasyonu & akıllı agent seçimi

---

## 1. Mevcut Durum

| Bileşen | Durum | Ne yapıyor? | Eksik |
|---------|-------|-------------|-------|
| `scripts/scanner.sh` | ✅ Çalışıyor | Envanter çıkarıyor (TSV) | İçerik analizi, skorlama yok |
| `scripts/inventory.sh` | ✅ Var | Ek envanter | İnceleme gerekli |
| `sources/` | ✅ Dolu | 16 submodule repo | — |
| `decisions/` | ⚠️ Boş/silinmiş | Karar kayıtları | Temiz başlangıç |
| `~/.claude/` | ✅ **FABRİKA RESET** (2026-04-12) | Sadece `.credentials.json` | Temiz hedef |
| Skorlama motoru | ❌ Yok | — | **Yapılacak** |
| Orchestrator | ❌ Yok | — | **Yapılacak** |
| Kurulum motoru | ❌ Yok | — | **Yapılacak** |
| Validation | ❌ Yok | — | **Yapılacak** |
| Kullanım izleme | ❌ Yok | — | **Yapılacak** |

---

## 2. Hedef Mimarinin 9 Aşaması

```
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────────┐
│ DISCOVER │─▶│ EXTRACT  │─▶│  SCORE   │─▶│  CURATE  │─▶│ORCHESTRATE │
│   (1)    │  │   (2)    │  │   (3)    │  │   (4)    │  │   (4.5)    │
└──────────┘  └──────────┘  └──────────┘  └──────────┘  └─────┬──────┘
                                                               │
              ┌──────────┐  ┌──────────┐  ┌──────────────┐  ┌──┴──────┐
              │ OPTIMIZE │◀─│ VALIDATE │◀─│   INSTALL    │◀─│ BUDGET  │
              │   (6)    │  │  (5.5)   │  │     (5)      │  │  (4.6)  │
              └──────────┘  └──────────┘  └──────────────┘  └─────────┘
```

**Aşama Tablosu:**

| # | Aşama | Amaç | Çıktı |
|---|-------|------|-------|
| 1 | **DISCOVER** | Repo'ları tara | `*-map.tsv` |
| 2 | **EXTRACT** | Metadata çıkar | `catalog.json` |
| 3 | **SCORE** | Rubric + self-scoring | `scored-catalog.json` |
| 4 | **CURATE** | Domain bazlı top-N seç | `selected.json` |
| **4.5** | **🆕 ORCHESTRATE** | Proje yaşam döngüsü map'i, meta-command | `lifecycle.json`, `/start-project` |
| **4.6** | **🆕 BUDGET** | Token maliyet hesabı, description kısaltma | `budget-profile.json` |
| **4.7** | **🆕 VALIDATE-AGENTS** | Agent disambiguation testi | `agent-overlap-report.json` |
| 5 | **INSTALL** | Temiz `~/.claude/` kurulumu + hooks + memory | Yüklü sistem |
| **5.5** | **🆕 SMOKE TEST** | End-to-end doğrulama | `smoke-test-report.md` |
| 6 | **OPTIMIZE** | Kullanım izleme + budama | `usage-report.json` |

**Diyagramlar:**
- **Pipeline akışı:** [diagrams/pipeline.mmd](diagrams/pipeline.mmd)
- **Skorlama akışı:** [diagrams/scoring.mmd](diagrams/scoring.mmd)
- **Kurulum akışı:** [diagrams/install.mmd](diagrams/install.mmd)
- 🆕 **Lifecycle orchestration:** [diagrams/lifecycle.mmd](diagrams/lifecycle.mmd)
- 🆕 **Validation flow:** [diagrams/validation.mmd](diagrams/validation.mmd)

---

## 3. Aşamaların Detayı

### Aşama 1 — DISCOVER (Envanter) ✅ %80 hazır

**Çıktı:** `decisions/{skills,agents,commands,hooks,prompts}-map.tsv`

**Mevcut:** `scanner.sh` repo'ları tarıyor, TSV çıkarıyor, çakışmaları tespit ediyor.

**Eksik:**
- `voltagent-subagents`, `continuous-claude-v3` gibi bazı repo'lar skill taramasına dahil değil
- Frontmatter parse edilmiyor (ham dosya boyutu kaydediliyor)

**Yapılacak:** scanner.sh'a 2 küçük yama — tüm repo'ları tarayacak şekilde genişlet.

---

### Aşama 2 — EXTRACT (Metadata Çıkarma)

**Çıktı:** `decisions/catalog.json` (her skill/agent/command için zengin metadata)

**Her bileşen için çıkarılacak:**
```json
{
  "id": "focused-fix",
  "type": "command",
  "source_repo": "alirezarezvani-claude-skills",
  "path": "sources/.../.claude/commands/focused-fix.md",
  "frontmatter": {
    "name": "focused-fix",
    "description": "5-phase systematic feature repair",
    "trigger": "when user reports a bug in specific feature",
    "keywords": ["debug", "fix", "bug"]
  },
  "content_metrics": {
    "size_bytes": 4231,
    "line_count": 118,
    "has_examples": true,
    "has_scripts": false,
    "has_references": true
  },
  "inferred_domain": null,     // Stage 3'te doldurulacak
  "quality_score": null,       // Stage 3'te doldurulacak
  "conflicts_with": []
}
```

**Teknoloji:** Python + `python-frontmatter` kütüphanesi.

---

### Aşama 3 — SCORE (Skorlama) ⭐ EN KRİTİK — SIFIR MALİYET

**İki katmanlı, tamamen bedava skorlama:**

#### 3a. Güçlendirilmiş Rubric Skorlama (deterministik, bedava)

Basit "frontmatter var mı" kontrolünden öte, içerik analizi yapan zengin bir kural seti:

**A. Yapısal puanlar (max 30):**
```
Has valid YAML frontmatter       +8
Description > 20 karakter        +6
Description domain keyword içerir +4
Has trigger/when-to-use hint     +4
Has examples block               +4
Has scripts/ or references/      +4
```

**B. İçerik kalite puanları (max 30):**
```
Markdown başlık hiyerarşisi var  +5
Kod bloğu sayısı 1-10 arası      +5   (0 veya 50+ ise 0)
"TODO", "TBD", "WIP" yok         +5
Line count 20-300 arası          +5
Uzun paragraflar değil (ortalama cümle < 30 kelime) +5
İmla/format düzgün (regex kontrol) +5
```

**C. Çapraz-repo sinyalleri (max 20):**
```
Aynı isim birden fazla repo'da var? +5 (popüler)
En büyük repo'daki sürüm?          +5
İçerik diğerlerinden zengin?       +5
Unique pattern var mı?             +5
```

**D. Domain match puanları (max 20):**
```
Project mgmt keyword yoğunluğu    0-5
Docs keyword yoğunluğu            0-5
Testing keyword yoğunluğu         0-5
Coding/arch keyword yoğunluğu     0-5
```

**TOPLAM MAX:** 100

**Eşikler:**
- Skor < 30 → ❌ ELİMİNE (çöp, eksik, bozuk)
- Skor 30-50 → ⚠️ BORDERLINE → Claude Code self-scoring
- Skor 50-75 → ✅ CANDIDATE
- Skor > 75 → ⭐ AUTO-KEEP

**Tahmini dağılım (1500 skill için):**
- ~900 ELİMİNE (çöp, yarım bırakılmış, TODO dolu)
- ~300 BORDERLINE (Claude Code skorlayacak)
- ~250 CANDIDATE
- ~50 AUTO-KEEP

#### 3b. Claude Code Self-Scoring (bedava, mevcut oturum üzerinden)

**Temel fikir:** Anthropic API'sine ayrı ödeme yapmak yerine, **zaten çalışan bu Claude Code oturumunu** skorlayıcı olarak kullanıyoruz. Task/Agent tool ile subagent spawn edilir.

```
┌──────────────────────────────┐
│  Borderline skills (~300)    │
└──────────────┬───────────────┘
               │
       ┌───────┴────────┐
       ▼                ▼
┌─────────────┐   ┌─────────────┐
│  Batch 1    │   │  Batch 2    │   ... (30'luk batch'ler)
│  30 skill   │   │  30 skill   │
└──────┬──────┘   └──────┬──────┘
       │                 │
       ▼                 ▼
┌──────────────────────────────┐
│  Subagent (Task tool)        │
│  - Skill içeriğini oku       │
│  - Rubric uygula             │
│  - JSON skor döndür          │
└──────────────┬───────────────┘
               ▼
       scored-catalog.json
```

**Subagent prompt şablonu:**
```
Sen bir Claude Code skill küratörüsün.
Sana 30 skill dosyasının yolu verilecek.
Her biri için oku ve şu JSON'ı döndür:

[
  {
    "id": "...",
    "clarity": 1-10,
    "specificity": 1-10,
    "utility": 1-10,
    "domain": "project-mgmt|docs|testing|coding|architecture|devops|other",
    "verdict": "keep|skip",
    "reasoning": "tek cümle"
  },
  ...
]

Eleme kriterleri:
- Boş veya TODO dolu → skip
- Çok belirsiz description → skip
- Tek bir proje/framework'e çok bağımlı → skip
- Açık, özgün, genel-amaçlı → keep
```

**Maliyet:**
- Anthropic API: **$0**
- Kullanıcı Claude Code subscription'ı zaten var
- Her batch ~15-20 saniye, 10 batch = ~3 dk
- Bir oturumda tüm borderline'ları skorlayabiliriz

**Avantaj:** Bu session'da bile çalışabilir, ek kurulum yok.

**Dezavantaj:** Context window sınırı var, batch boyutu 30-50'yi geçemez. 10+ batch spawn etmek gerekir.

#### 3c. Sonuç: Skorlanmış Katalog

`decisions/scored-catalog.json` — her bileşen için final skor + domain + verdict.

---

### Aşama 4 — CURATE (Küratörlük)

**Çıktı:**
- `decisions/selected.json` — kurulacak final liste
- `decisions/bundles/` — domain bazlı paketler

**Alt adımlar:**

1. **Domain bazlı gruplama:**
   ```
   project-mgmt/   → planner, roadmap, sprint, milestone skills
   docs/           → api-docs, readme, changelog, tutorial skills
   testing/        → tdd, e2e, coverage, mutation skills
   coding/         → refactor, lint, review, clean-code skills
   architecture/   → c4, ddd, microservices, patterns skills
   devops/         → docker, k8s, ci-cd, deploy skills
   ```

2. **Çakışma çözümü:** Aynı isimli skill'ler için en yüksek skorlu olanı seç.

3. **Max budget uygulaması:** Her domain için max 30 skill tut. Top-N seçimi.

4. **Human-in-the-loop review:** `selected.json` dosyası sana gösterilir, manuel onay/red yapabilirsin.

5. **Bundle oluşturma:** "essential" (her projede lazım), "optional" (projeye özel), "experimental" (denemelik).

---

### 🆕 Aşama 4.5 — ORCHESTRATE (Yaşam Döngüsü Orkestrasyonu)

**Amaç:** Claude'un kullanıcıyı **bir proje baştan sona** yönlendirmesini sağlayan meta-katman. Seçilen skill/agent'ları proje fazlarına haritalamak.

**Çıktı:**
- `decisions/lifecycle.json` — faz → agent/skill eşlemesi
- `~/.claude/commands/start-project.md` — meta-command
- `~/.claude/skills/project-lifecycle/SKILL.md` — orkestrasyon skill'i

**Proje Yaşam Döngüsü (8 faz):**

```
┌─────────────────────────────────────────────────────────────────┐
│ Phase 1: DISCOVERY     "Ne yapıyoruz ve neden?"                 │
│   Agents: business-analyst, market-researcher, ux-researcher    │
│   Skills: brainstorming, jobs-to-be-done, user-personas         │
│   Output: PRD, kullanıcı hikayeleri                             │
├─────────────────────────────────────────────────────────────────┤
│ Phase 2: PLANNING      "Nasıl yapacağız?"                       │
│   Agents: planner, architect, product-manager                   │
│   Skills: project-planning, risk-analysis, roadmap              │
│   Output: Plan, mimari kararlar, sprint                         │
├─────────────────────────────────────────────────────────────────┤
│ Phase 3: DESIGN        "Neye benzeyecek?"                       │
│   Agents: ui-designer, api-designer, database-architect         │
│   Skills: design-system, api-design, schema-design              │
│   Output: Wireframe, API spec, DB schema                        │
├─────────────────────────────────────────────────────────────────┤
│ Phase 4: BUILD         "Kod yazma"                              │
│   Agents: fullstack/frontend/backend-developer                  │
│   Skills: tdd-guide, coding-standards, refactoring              │
│   Output: Çalışan kod                                           │
├─────────────────────────────────────────────────────────────────┤
│ Phase 5: TEST          "Doğru mu çalışıyor?"                    │
│   Agents: tdd-guide, test-automator, qa-expert                  │
│   Skills: unit-testing, e2e-testing, coverage                   │
│   Output: Test suite, coverage raporu                           │
├─────────────────────────────────────────────────────────────────┤
│ Phase 6: DOCUMENT      "Nasıl kullanılır?"                      │
│   Agents: technical-writer, api-documenter, doc-updater         │
│   Skills: readme, api-docs, tutorials                           │
│   Output: README, API docs, kullanım rehberleri                 │
├─────────────────────────────────────────────────────────────────┤
│ Phase 7: SHIP          "Canlıya nasıl çıkar?"                   │
│   Agents: deployment-engineer, devops-engineer, sre-engineer    │
│   Skills: docker, ci-cd, deploy-checklist                       │
│   Output: Production deployment                                 │
├─────────────────────────────────────────────────────────────────┤
│ Phase 8: MAINTAIN      "Nasıl sağlıklı kalır?"                  │
│   Agents: refactor-cleaner, performance-engineer, security      │
│   Skills: monitoring, profiling, dep-audit                      │
│   Output: Monitoring dashboard, bakım rehberleri                │
└─────────────────────────────────────────────────────────────────┘
```

**`/start-project` Meta-Command**

Kullanıcı projeye başlarken `/start-project` çalıştırır. Bu komut:

1. Kullanıcıya proje türünü sorar (web app, mobile, CLI, library, SaaS...)
2. Yaşam döngüsünü başlatır, faz 1'den başlar
3. Her fazda uygun agent'ları otomatik çağırır
4. Faz tamamlandığında kullanıcıya "Sonraki faza geçmeye hazır mısın?" diye sorar
5. `decisions/project-state.json` dosyasına ilerlemeyi kaydeder (hangi fazda, neler tamam)
6. Fazlar arası handoff'larda önceki fazın çıktısını sonraki faza taşır

**Örnek akış:**
```
User: /start-project
Claude: Nasıl bir proje? [web/mobile/cli/lib/saas]
User: SaaS
Claude: [Phase 1 başlıyor] business-analyst agent çağrılıyor...
        "Bu SaaS hangi problemi çözüyor? Hedef kullanıcı kim?"
...
Claude: [Phase 1 tamam] PRD docs/PRD.md'ye yazıldı.
        Phase 2 (Planning) başlayayım mı?
User: Evet
Claude: [Phase 2] planner + architect çağrılıyor...
```

**Lifecycle.json şeması:**
```json
{
  "phases": [
    {
      "id": "discovery",
      "name": "Discovery",
      "order": 1,
      "entry_criteria": "project type selected",
      "exit_criteria": "PRD written",
      "agents": ["business-analyst", "market-researcher"],
      "skills": ["brainstorming", "jobs-to-be-done"],
      "outputs": ["docs/PRD.md", "docs/user-stories.md"],
      "typical_duration": "1-2 sessions"
    },
    ...
  ],
  "handoffs": [
    {"from": "discovery", "to": "planning", "payload": "PRD + user stories"}
  ]
}
```

---

### 🆕 Aşama 4.6 — BUDGET (Token Bütçesi)

**Amaç:** Kurulacak sistemin Claude Code başlarken yüklediği context'i optimize etmek. **Token disiplini olmadan iyi skill kurulumu da faydasız olur.**

**Çıktı:**
- `decisions/budget-profile.json` — her bileşenin token maliyeti
- `decisions/selected-optimized.json` — budget'a sığdırılmış final liste

**Context Budget Hesabı**

Claude Code başlarken şunları yükler:
```
1. System prompt         ~2,000 token (sabit)
2. CLAUDE.md             ~500-2,000 token (proje)
3. Rules (common + lang) ~5,000 token
4. Agent descriptions    ~50 token × N agent
5. Skill metadata        ~100 token × N skill
6. Commands              ~lazy (sadece /çağrıldığında)
```

**Hedef budget:**
```
TOTAL STARTUP BUDGET:   25,000 token (max)
  - System              2,000
  - Rules               5,000
  - Agents (max 100)    5,000  ← 50 token × 100
  - Skills (max 150)   15,000  ← 100 token × 150
  - Buffer              ~3,000 (CLAUDE.md için)
```

**Optimizasyon kuralları:**

1. **Agent description maks 60 token (~45 kelime)**
   - Fazla uzun ise otomatik kısalt
   - Örnek: "Use this agent when..." → çıkar, sadece "X yapar, Y'de kullan"

2. **Skill description maks 100 token**
   - Frontmatter'daki `description` alanı
   - Uzun olanlar sayfa body'sine taşınır

3. **Agent sayısı ≤ 100**
   - Curate aşamasında daha sert filtreleme

4. **Skill sayısı ≤ 150**
   - Stage 4'teki 200 hedefi 150'ye düşürülür
   - Her domain için 20-25 skill

5. **Lazy loading garantisi**
   - Skill body (SKILL.md içeriği) startup'ta yüklenmez
   - Sadece trigger edildiğinde okunur
   - Frontmatter description + trigger alanları yeterli olmalı

**budget.py hesabı:**
```python
def calculate_budget(selected):
    total = 2000  # system
    total += count_tokens(read_rules())
    for agent in selected.agents:
        total += count_tokens(agent.description)
    for skill in selected.skills:
        total += count_tokens(skill.frontmatter)
    return total

def optimize(selected, max_budget=25000):
    # Uzun description'ları kısalt
    # Sığmazsa en düşük skorludan başlayarak at
    ...
```

**Output:**
```json
{
  "startup_budget_tokens": 23450,
  "max_budget": 25000,
  "breakdown": {
    "system": 2000,
    "rules": 4800,
    "agents": {"count": 87, "tokens": 4640},
    "skills": {"count": 142, "tokens": 10210},
    "buffer": 1800
  },
  "optimizations_applied": [
    "Shortened 23 agent descriptions",
    "Removed 8 skills that pushed over budget"
  ]
}
```

---

### 🆕 Aşama 4.7 — VALIDATE-AGENTS (Agent Seçim Doğrulama)

**Amaç:** Claude'un doğru agent'ı **garantili** seçebilmesi için agent description'larının birbirinden ayırt edilebilir olduğunu doğrulamak.

**Problem:** Eğer 10 tane "code review" yapan agent varsa, Claude hangisini çağıracağını bilmez. Seçim ambigu olur.

**Çıktı:**
- `decisions/agent-overlap-report.json`
- `decisions/agent-decision-tree.md`

**Test protokolü:**

1. **Overlap detection (TF-IDF bazlı)**
   - Her agent description'ından keyword vektörü çıkar
   - Cosine similarity hesapla
   - Skor > 0.7 olan çiftler "overlap" olarak işaretle

2. **Disambiguation test (self-scoring ile)**
   - 20 tane örnek kullanıcı isteği hazırla:
     - "bu kodu gözden geçir"
     - "type hatalarını bul"
     - "mimari karar ver"
     - "SQL optimize et"
     - ...
   - Her istek için subagent'a sor: "Bu istek için hangi agent çağrılmalı?"
   - Subagent kesin bir cevap verebiliyor mu, yoksa tereddüt ediyor mu?
   - Tereddütlü olanlar → iyileştirme gerekli

3. **Description rewriting**
   - Overlap tespit edilen agent'ların description'ları yeniden yazılır
   - "When to use X" net olmalı
   - "Not when..." eklenir (başka agent tercih edilen durumlar)

**Karar ağacı çıktısı:**
```markdown
## Agent Seçim Kılavuzu

### "Code review yap" istendiğinde:
- TypeScript dosyası değişti → typescript-reviewer
- Güvenlik odaklı istek → security-reviewer
- Mimari seviye → architect-reviewer
- Genel kalite → code-reviewer ← default

### "Bug var" istendiğinde:
- Build hatası → build-error-resolver
- Runtime hata → debugger
- Test kırıldı → tdd-guide
- Performans düşük → performance-engineer
...
```

Bu dosya hem kullanıcı için referans, hem de Claude'un sistem prompt'una eklenir.

---

### Aşama 5 — INSTALL (Kurulum) — FABRİKA RESET SONRASI

**Çıktı:** `~/.claude/{skills,agents,commands,hooks,rules}/` + `~/.claude/settings.json` + `~/.claude/CLAUDE.md` + memory setup

**Mevcut durum:** `~/.claude/` boş (sadece `.credentials.json`). Çakışma yok, temiz kurulum.

**Kurulum adımları:**

```
1. PRE-CHECK   → ~/.claude/ boş mu doğrula (credentials hariç)
2. STRUCTURE   → Dizinleri oluştur: skills/, agents/, commands/, hooks/, rules/, projects/
3. COPY-CORE   → selected.json'dan dosyaları hedefe kopyala
4. INSTALL-HOOKS → hooks/ dizinine format/lint/type-check hook'ları
5. WRITE-SETTINGS → settings.json üret (hook path'leri, allowedTools, vs.)
6. WRITE-CLAUDE-MD → Global CLAUDE.md üret (kullanım rehberi)
7. INSTALL-ORCHESTRATOR → /start-project command + lifecycle skill
8. INSTALL-DECISION-TREE → agent-decision-tree.md → rules/ altına
9. SETUP-MEMORY → projects/ altında bu projenin MEMORY.md'sini oluştur
10. MANIFEST → install-manifest.json'a tüm kayıtları yaz
11. CHECKSUM → Her dosya için SHA256, manifest'e ekle
```

**Önemli dosyalar (kurulum sonrası):**

```
~/.claude/
├── .credentials.json        [korundu]
├── settings.json            [YENİ - hook config]
├── CLAUDE.md                [YENİ - global kullanım rehberi]
├── skills/                  [YENİ - ~150 skill]
├── agents/                  [YENİ - ~100 agent]
├── commands/
│   ├── start-project.md    [YENİ - meta-command]
│   └── ... (~30 command)
├── hooks/                   [YENİ - format/lint/test hooks]
├── rules/
│   ├── common/              [YENİ - temel kurallar]
│   ├── agent-decision-tree.md [YENİ]
│   └── token-budget.md      [YENİ]
└── projects/
    └── c--Users-Dell-.../
        └── MEMORY.md        [YENİ - proje hafızası]
```

**Settings.json şablonu:**
```json
{
  "hooks": {
    "PostToolUse": [
      {"matcher": "Write|Edit", "command": "<format hook>"}
    ],
    "Stop": [
      {"command": "<verification hook>"}
    ]
  },
  "alwaysThinkingEnabled": true,
  "maxThinkingTokens": 15000
}
```

---

### 🆕 Aşama 5.5 — SMOKE TEST

**Amaç:** Kurulum sonrası sistemin **gerçekten çalıştığını** doğrulamak. Claude doğru agent'ları çağırıyor mu, token budget'ı aşılıyor mu, lifecycle orchestrator düzgün mü?

**Çıktı:** `decisions/smoke-test-report.md`

**Test senaryoları:**

```
Test 1: Startup Budget
  Beklenen: ~25k token altında
  Ölçüm: Claude Code cold start → context token count

Test 2: Agent Selection
  20 örnek istekle (test 4.7'deki)
  Beklenen: Her istek için doğru agent seçiliyor
  Ölçüm: Subagent ile doğrulama

Test 3: Lifecycle Orchestrator
  Senaryo: "Next.js SaaS projesi başlat"
  Beklenen: /start-project çalışır, Phase 1'e girer, business-analyst çağırır
  Ölçüm: Akış tamamlanıyor mu

Test 4: Skill Auto-trigger
  Senaryo: "kodu refactor et"
  Beklenen: refactoring skill'i otomatik tetiklenir
  Ölçüm: Doğru skill çağrılıyor mu

Test 5: Hook Execution
  Senaryo: Bir .ts dosyasına Edit yap
  Beklenen: PostToolUse hook → prettier/eslint çalışır
  Ölçüm: Hook başarılı mı

Test 6: Memory Persistence
  Senaryo: MEMORY.md'ye test entry ekle, yeni session başlat
  Beklenen: Yeni session'da memory yüklenir
  Ölçüm: Memory read edildi mi
```

**Başarı kriteri:** 6/6 test geçmeli. Geçmezse ilgili aşamaya dön, düzelt, tekrar test.

---

---

### Aşama 6 — OPTIMIZE (Ölçme ve Budama)

**Çıktı:** `decisions/usage-report.json` + otomatik budama önerileri

**Metrikler:**
- Hangi skill hiç tetiklenmedi? (1 ay içinde)
- Hangi agent en çok çağrıldı?
- Token kullanımı skill bazında nasıl?
- Kullanıcı hangi `/command`leri çalıştırdı?

**Kaynak:** `~/.claude/cost-tracker.log`, `~/.claude/bash-commands.log` zaten mevcut.

**Otomatik budama:**
- 30 gün kullanılmayan skill → "deprecate" havuzuna taşı
- 90 gün kullanılmayan skill → kaldır
- Budama öncesi dry-run + onay.

---

## 4. Teknoloji Yığını

| Katman | Araç | Neden |
|--------|------|-------|
| Scanner | Bash (mevcut) | Basit, dosya sistemi odaklı |
| Extractor | Python + `python-frontmatter` | YAML parse için gerekli |
| Scorer (rubric) | Python stdlib | Hızlı, deterministik, bağımlılıksız |
| Scorer (self-scoring) | Claude Code Task tool | Sıfır maliyet, mevcut oturum |
| Curator | Python + JSON | İnsan okuyabilen format |
| 🆕 Orchestrator | Python + Markdown template | Lifecycle JSON + meta-command üretimi |
| 🆕 Budget calculator | Python + `tiktoken` (opsiyonel) | Token sayımı |
| 🆕 Agent validator | Python (TF-IDF) + Claude Code Task | Overlap detection |
| Installer | Bash + rsync | Atomic, checksum destekli |
| 🆕 Smoke tester | Bash + Claude Code Task | End-to-end doğrulama |
| Tracker | Bash + jq | Log parsing |

**Dizin yapısı:**
```
CloaudeCodeCTO/
├── scripts/
│   ├── scanner.sh              [MEVCUT]
│   ├── inventory.sh            [MEVCUT]
│   ├── extractor.py            [YENİ — Stage 2]
│   ├── scorer_rubric.py        [YENİ — Stage 3a]
│   ├── scorer_self.py          [YENİ — Stage 3b, Task tool wrapper]
│   ├── curator.py              [YENİ — Stage 4]
│   ├── orchestrator.py         [YENİ — Stage 4.5]
│   ├── budget.py               [YENİ — Stage 4.6]
│   ├── validate_agents.py      [YENİ — Stage 4.7]
│   ├── installer.sh            [YENİ — Stage 5]
│   ├── smoke_test.sh           [YENİ — Stage 5.5]
│   └── tracker.sh              [YENİ — Stage 6]
├── decisions/
│   ├── skills-map.tsv          [Stage 1]
│   ├── agents-map.tsv          [Stage 1]
│   ├── commands-map.tsv        [Stage 1]
│   ├── catalog.json            [Stage 2]
│   ├── scored-catalog.json     [Stage 3]
│   ├── selected.json           [Stage 4]
│   ├── lifecycle.json          [Stage 4.5]
│   ├── budget-profile.json     [Stage 4.6]
│   ├── agent-overlap-report.json [Stage 4.7]
│   ├── agent-decision-tree.md  [Stage 4.7]
│   ├── install-manifest.json   [Stage 5]
│   ├── smoke-test-report.md    [Stage 5.5]
│   └── usage-report.json       [Stage 6]
├── templates/                   [YENİ]
│   ├── start-project.md.tpl    [meta-command şablonu]
│   ├── CLAUDE.md.tpl           [global rehber şablonu]
│   ├── settings.json.tpl       [hooks config şablonu]
│   └── hooks/                  [format/lint/type-check hook şablonları]
└── docs/
    ├── PLAN.md                 [BU DOSYA]
    └── diagrams/
        ├── pipeline.mmd
        ├── scoring.mmd
        ├── install.mmd
        ├── lifecycle.mmd       [YENİ]
        └── validation.mmd      [YENİ]
```

---

## 5. Zaman ve Maliyet Tahmini — SIFIR MALİYET

| Aşama | Geliştirme | Çalıştırma | Harici Maliyet |
|-------|------------|------------|----------------|
| 1. Discover | 30 dk (yama) | 1 dk | **$0** |
| 2. Extract | 2 saat | 2 dk | **$0** |
| 3a. Rubric | 2 saat | 30 sn | **$0** |
| 3b. Self-scoring | 1 saat | 3-5 dk | **$0** (mevcut oturum) |
| 4. Curate | 2 saat | İnteraktif | **$0** |
| 🆕 4.5. Orchestrate | 3 saat | 5 dk | **$0** |
| 🆕 4.6. Budget | 1.5 saat | 1 dk | **$0** |
| 🆕 4.7. Validate Agents | 2 saat | 10 dk | **$0** (self-scoring) |
| 5. Install | 3 saat | 5 dk | **$0** |
| 🆕 5.5. Smoke Test | 2 saat | 10 dk | **$0** (self-scoring) |
| 6. Optimize | 1 saat | Sürekli | **$0** |
| **TOPLAM** | **~20 saat** | **~45 dk** | **$0** |

**Sıfır maliyet kuralları:**
1. ❌ Anthropic API key kullanılmıyor
2. ❌ Ücretli üçüncü parti servis yok
3. ❌ Bulut hizmeti yok
4. ✅ Sadece yerel araçlar: bash, python3, jq, grep, sort
5. ✅ Claude Code zaten kurulu, skorlayıcı olarak **mevcut oturum** kullanılıyor
6. ✅ Python bağımlılıkları stdlib + `python-frontmatter` (bedava, pip ile)

**Geliştirme süresi 11 saat** — bu birkaç oturuma yayılır. Her aşamadan sonra duralayıp gözden geçiririz.

---

## 6. Açık Sorular (Senden İstenen Kararlar)

1. ~~**Mevcut `~/.claude/` içeriği ne olacak?**~~ ✅ **ÇÖZÜLDÜ** — 2026-04-12 fabrika reset yapıldı, sadece `.credentials.json` kaldı.

2. **Domain öncelikleri**
   - [ ] project-mgmt (1)
   - [ ] docs (2)
   - [ ] testing (3)
   - [ ] coding (4)
   - [ ] architecture (5)
   - [ ] devops (6)

3. **Hedef sayılar (budget'e göre güncellendi)**
   - Agents: **~100** (was: belirsiz)
   - Skills: **~150** (was: 200)
   - Commands: **~30**
   - Startup token budget: **~25,000 token**

4. **Skorlama yaklaşımı**
   - [ ] Sadece rubric (hızlı, %80 kalite)
   - [ ] Rubric + self-scoring (yavaş ama %90 kalite) ← **önerim**

5. **Lifecycle orchestrator kapsamı**
   - [ ] 8 faz hepsi (tam kapsam) ← **önerim**
   - [ ] Sadece 4 ana faz (planning/build/test/docs)
   - [ ] Meta-command yok, sadece domain'li skill'ler

6. **İlk uygulama adımı**
   - [ ] Stage 1+2 → dur, gözden geçir ← **önerim**
   - [ ] Stage 1+2+3 tek seferde
   - [ ] Baştan sona otomatik, her aşama sonunda rapor

---

## 7. Anlaşma Noktaları

Devam etmeden önce şunlarda hemfikir olmalıyız:

- [ ] 9 aşamalı pipeline (6 orijinal + 3 yeni + 5.5) uygun mu?
- [ ] Rubric + self-scoring yaklaşımı uygun mu?
- [ ] Token budget 25k startup limiti makul mu?
- [ ] Lifecycle orchestrator ile `/start-project` meta-command konsepti uygun mu?
- [ ] Agent disambiguation testi gerekli mi?
- [ ] Smoke test ile doğrulama adımı yeterli mi?
- [ ] `decisions/` tek doğruluk kaynağı mı?

---

## 8. İstekleri Karşılama Matrisi

Senin ilk mesajındaki istekler → Plan'daki karşılıkları:

| İstek | Karşılandığı Aşama | Not |
|-------|---------------------|-----|
| "Repo'lardan en iyi skill/agent/command al" | 1-4 | Discover → Curate |
| "Bir dosyada topla" | 2, 4 | catalog.json → selected.json |
| "Proje yönetimi, dokümantasyon, test, kod yazımı" | 4 | Domain bazlı gruplama |
| **"Claude'un kullanıcıyı yönlendirerek proje baştan sona yapması"** | **4.5** 🆕 | Lifecycle orchestrator, /start-project |
| **"Token optimizasyonu"** | **4.6** 🆕 | Budget profile, description kısaltma |
| **"Seçmesi gereken agentları bilebilsin"** | **4.7** 🆕 | Disambiguation test, decision tree |
| "Sıfır maliyet" | Hepsi | Anthropic API yok, self-scoring |
| "Gereken scripti/scanner'ı yaz" | 1 | scanner.sh güncelle |
| "Fabrika reset" | ✅ | 2026-04-12 yapıldı |

**Karşılanma oranı:** %100 ✅

---

**Sıradaki adım:** Yukarıdaki 6 soruya cevap ver, ben de (önerim) Stage 1+2'yi yazmaya başlayayım. Onayından sonra her aşama sonunda duralayıp sonuçları birlikte gözden geçireceğiz.
