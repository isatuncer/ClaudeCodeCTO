<div dir="rtl">

# ClaudeCodeCTO

> **اللغة:** [English](../../README.md) · [Türkçe](../../README.tr.md) · [Deutsch](README.de.md) · [Español](README.es.md) · [Français](README.fr.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md) · [Русский](README.ru.md) · **العربية**

> حوّل Claude Code إلى CTO لدورة حياة كاملة: 3,025 مهارة ووكيل وأمر مختارة يدوياً من 17 مستودع مفتوح المصدر رائد، مُثبّتة في `~/.claude/` بدون أي تكلفة خارجية.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-3025-green.svg)](../../decisions/selected.json)

---

## ما هذا؟

ClaudeCodeCTO هو **نظام تنظيم وتثبيت** يأخذ أفضل المهارات والوكلاء والأوامر من 17 مستودع Claude Code عام ويثبّتها في دليل `~/.claude/` الخاص بك كمجموعة أدوات موحدة.

النتيجة: تثبيت Claude Code يمكن أن يرشدك **من الفكرة إلى الإنتاج** — عبر الاكتشاف، التخطيط، التصميم، البناء، الاختبار، التوثيق، الشحن، والصيانة — باستخدام وكلاء متخصصين في كل مرحلة.

فكّر في الأمر كتوظيف CTO لمشروعك: شخص يعرف مسبقاً كل framework، وكل استراتيجية اختبار، وكل نمط نشر، ويعرف بالضبط أي متخصص يجب استدعاؤه في كل خطوة.

---

## البدء السريع — أمر واحد

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

أو مع `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

الدليل الهدف الافتراضي هو `$HOME/ClaudeCodeCTO`. للاستبدال:

```bash
CCCTO_DIR=/custom/path bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### البدء اليدوي

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### متغيرات البيئة

| المتغير | الافتراضي | الوصف |
|---|---|---|
| `CCCTO_DIR` | `$HOME/ClaudeCodeCTO` | دليل الاستنساخ الهدف |
| `CCCTO_BRANCH` | `main` | الفرع المراد استنساخه |
| `CCCTO_AUTO` | `0` | `1` = وضع غير تفاعلي |
| `CCCTO_NO_INSTALL` | `0` | `1` = تخطي تثبيت `~/.claude/` |

---

## الميزات

- **3,025 مكوّناً** — 2,044 مهارة + 550 وكيل + 431 أمر، منظمة من 17 مستودع
- **دورة حياة من 8 مراحل** — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **صفر تكلفة خارجية** — لا استدعاءات API من Anthropic، لا خدمات مدفوعة، لا قياسات عن بعد
- **متوافق مع إعادة ضبط المصنع** — يعمل على `~/.claude/` نظيف، يحافظ على `.credentials.json`
- **تثبيت ذري مع نسخ احتياطي** — كل شيء يُرحّل أولاً في `/c/tmp/`، ثم يُحفظ
- **تفاعلي افتراضياً** — يؤكد كل إجراء مدمّر؛ `--auto` للـ CI
- **قابل للاستئناف** — مراحل الخط تكتب في `decisions/`، ويمكن إعادة التشغيل من أي نقطة تفتيش
- **مصدر حقيقة واحد** — `decisions/` فقط هو الموثوق؛ لا تكوين مخفي
- **Windows + Linux + macOS** — يعي المسارات (يستخدم `cygpath` على Windows)

---

## ما يتم تثبيته

```
~/.claude/
├── .credentials.json              (محفوظ)
├── CLAUDE.md                      تعليمات عامة (مُولّدة)
├── settings.json                  تكوين harness (مُولّد)
├── skills/                        2,044 مهارة
│   └── project-lifecycle/         الموجّه الفوقي (8 مراحل)
├── agents/                        550 وكيلاً متخصصاً
├── commands/                      431 أمر slash
│   └── start-project.md           نقطة دخول /start-project لدورة الحياة
├── rules/
│   └── agent-decision-tree.md     أي وكيل لأي مهمة
└── config/
    └── lifecycle.json             خريطة المشروع من 8 مراحل
```

**التصنيف حسب المجال:**

| المجال | العدد | أمثلة |
|---|---:|---|
| devops | 541 | docker، kubernetes، terraform، CI/CD |
| project-mgmt | 349 | التخطيط، OKRs، سير عمل sprint |
| frontend | 333 | React، Vue، Next.js، أنظمة التصميم |
| coding | 287 | بناؤون ومراجعون خاصون بلغات |
| backend | 183 | APIs، قواعد البيانات، الخدمات المصغرة |
| security | 143 | التدقيق، اختبار الاختراق، الامتثال |
| testing | 140 | وحدة، تكامل، E2E، طفرة |
| data-ai | 132 | خطوط ML، تكامل LLM، RAG |
| docs | 120 | الكتابة التقنية، مرجع API |
| architecture | 81 | مخططات C4، ADRs، تصميم النظام |
| other | 79 | متنوع |

يتم حفظ نسخة احتياطية من `~/.claude/` السابق تلقائياً في `/c/tmp/claude-install-backup-<timestamp>/` قبل أي تغييرات.

---

## دورة حياة المشروع من 8 مراحل

بعد التثبيت، تشغيل `/start-project` في جلسة Claude Code جديدة يُفعّل موجّه دورة الحياة.

| المرحلة | الاسم | الشعار | الوكلاء الرئيسيون |
|---|---|---|---|
| 1 | Discovery | "ماذا ولماذا؟" | business-analyst، market-researcher، ux-researcher |
| 2 | Planning | "كيف نبني؟" | planner، architect، product-manager |
| 3 | Design | "كيف يبدو؟" | ui-designer، api-designer، database-architect |
| 4 | Build | "كتابة الكود" | fullstack/frontend/backend-developer، tdd-guide |
| 5 | Test | "هل يعمل؟" | test-automator، qa-expert، e2e-runner |
| 6 | Document | "كيف يُستخدم؟" | technical-writer، api-documenter |
| 7 | Ship | "كيف يصل للإنتاج؟" | deployment-engineer، devops-engineer، sre-engineer |
| 8 | Maintain | "كيف يبقى صحياً؟" | performance-engineer، security-engineer، refactor-cleaner |

كل مرحلة قابلة للاستئناف. إذا أغلقت الجلسة، سيتذكر `decisions/project-state.json` أين كنت.

---

## خط التنظيم

خط الأنابيب ذو 9 مراحل يبني `decisions/selected.json`. يعمل فقط على جهاز المشرف — المستخدمون النهائيون لا يرونه أبداً.

```
1. DISCOVER     قائمة TSV للمكوّنات الخام
2. EXTRACT      catalog.json بمعلومات وصفية غنية
3a. SCORE       مقياس حتمي من 100 نقطة
3b. SELF-SCORE  تقييم دلالي عبر الوكلاء الفرعيين لـ Claude Code
4. CURATE       إزالة التكرار + التجميع حسب المجال → selected.json
4.5 ORCHESTRATE ربط بدورة الحياة من 8 مراحل
4.6 BUDGET      ملف تعريف تكلفة الرموز (~105K عند البدء)
4.7 VALIDATE    22 زوج تداخل → شجرة قرار
5. INSTALL      تثبيت ذري مُرحّل + نسخ احتياطي
5.5 SMOKE TEST  تحقق هيكلي من 8 اختبارات
6. OPTIMIZE     تشذيب قائم على الاستخدام (اختياري)
```

### مقياس الـ 100 نقطة

| البُعد | النقاط | ما يُقاس |
|---|---:|---|
| هيكلي | 30 | YAML frontmatter صالح، الحقول المطلوبة، حجم معقول |
| محتوى | 30 | طول الوصف، الأمثلة، شروط تشغيل واضحة |
| عبر المستودعات | 20 | التفرد بين المستودعات، الحداثة |
| ملاءمة المجال | 20 | مكافأة المجال ذي الأولوية |

---

## المستودعات المصدر

17 وحدة فرعية نشطة. جميع التراخيص محفوظة في الدلائل الخاصة بها.

| المستودع | التركيز | Skills | Agents | Commands |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | مهارات Anthropic الرسمية | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | مجموعة أدوات شاملة | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | مجموعة مهارات ضخمة | 1,404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | متخصصو المجال | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | وكلاء فرعيون منظمون | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | مجموعة أدوات كاملة | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | سير عمل تطوير مستمر | 156 | 32 | 0 |

القائمة الكاملة في [`.gitmodules`](../../.gitmodules).

---

## المتطلبات

- **Claude Code** مُثبّت مع بيانات الاعتماد في `~/.claude/.credentials.json`
- **Python 3.8+** مع `PyYAML` (مُثبّت تلقائياً بواسطة `install.sh`)
- **Bash** 4+ (git-bash على Windows)
- **Git** مع دعم الوحدات الفرعية
- **~1 جيجابايت قرص حر** للوحدات الفرعية + المخرجات المُولّدة
- **~5–15 دقيقة** للإعداد الأولي

المنصات المدعومة: Windows (git-bash)، macOS، Linux.

---

## إلغاء التثبيت

```bash
cd ClaudeCodeCTO
bash scripts/uninstall.sh --dry-run   # معاينة ما سيتم حذفه
bash scripts/uninstall.sh             # الحذف الفعلي
```

يقرأ سكريبت إلغاء التثبيت `decisions/install.tsv` ويحذف **فقط** ما قام ClaudeCodeCTO بتثبيته.

**محمي — لا يُمس أبدًا:** `~/.claude/.credentials.json` (تسجيل دخول Claude Code)، `~/.claude/projects/` (ذاكرة المشاريع)، المكونات التي أضفتها بنفسك، و `CLAUDE.md`/`settings.json` إذا قمت بتحريرها.

الأعلام: `--dry-run`، `--yes`/`-y`، `--keep-generated`.

---

## استكشاف الأخطاء

### الإعداد يفشل عند "Environment Check"

```bash
pip install pyyaml
```

### فشل سحب الوحدات الفرعية

```bash
git submodule sync
git submodule update --init --recursive --force
```

### التثبيت يفشل في المنتصف

النسخة الاحتياطية في `/c/tmp/claude-install-backup-<timestamp>/`. للاستعادة:

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code لا يرى المهارات الجديدة

ابدأ **جلسة Claude Code جديدة**. يتم تجميد موجّه النظام عند بدء الجلسة.

---

## الأسئلة الشائعة

**س: لماذا "صفر تكلفة"؟ Claude Code يستخدم أرصدة API الخاصة بي، أليس كذلك؟**
نعم — Claude Code يستخدم جلستك الحالية. ما هو "صفر تكلفة" هو هذا الخط: لا مفاتيح API منفصلة من Anthropic، لا خدمات طرف ثالث، لا تسجيل نقاط مدفوع.

**س: هل سيكتب فوق `~/.claude/` الحالي الخاص بي؟**
لا — المُثبّت أولاً ينسخ كل شيء احتياطياً إلى `/c/tmp/claude-install-backup-<timestamp>/`، ثم يُرحّل التثبيت الجديد في `/c/tmp/claude-install-stage-<timestamp>/`، ثم ينسخ الملفات. إذا حدث خطأ، يمكنك الاستعادة من دليل النسخة الاحتياطية.

**س: هل يمكنني اختيار المكوّنات التي أُثبّتها؟**
نعم — قم بتحرير `decisions/selected.json` قبل تشغيل `setup.sh`.

**س: ما هي تكلفة الرموز لتحميل 2,044 مهارة؟**
حوالي **105K رمز** عند بدء الجلسة. معظم المهارات تُحمّل بشكل كسول عند تفعيلها.

---

## الترخيص

MIT — انظر [LICENSE](../../LICENSE).

## الشكر والتقدير

هذا المشروع ينظم المحتوى من 17 مستودع مفتوح المصدر. انظر [`.gitmodules`](../../.gitmodules) للقائمة الكاملة. جميع تراخيص الوحدات الفرعية محفوظة في الدلائل الخاصة بها `sources/<repo>/`.

بُني بواسطة [@isatuncer](https://github.com/isatuncer). PRs والقضايا مُرحّب بها.

</div>
