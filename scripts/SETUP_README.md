# scripts/setup.sh — Full Pipeline Automation

`setup.sh`, CloaudeCodeCTO'nun tüm pipeline'ını tek komutla çalıştıran orkestrasyon script'idir. Submodule güncellemelerini algılar, pipeline'ı yeniden çalıştırır, Claude Code'a kurulum yapar ve decisions/ değişikliklerini git'e commit eder.

## Komutlar

```bash
# Tam kurulum — her adımda sorar, onay bekler (ÖNERİLEN)
bash scripts/setup.sh

# Tüm onayları atlayıp otomatik çalıştır (cron için)
bash scripts/setup.sh --auto

# Gerçek bir şey yapmadan ne olacağını göster
bash scripts/setup.sh --dry-run

# Sadece kontrol et (pull yok, install yok, commit yok)
bash scripts/setup.sh --check

# Pipeline'ı çalıştır ama install adımını atla
bash scripts/setup.sh --no-install

# Commit yap ama push yapma
bash scripts/setup.sh --no-push

# Yardım
bash scripts/setup.sh --help
```

## 12 Aşama

Her aşamada kullanıcıya bilgi verilir. Kritik adımlarda (submodule pull, install, git commit, git push) onay istenir.

| # | Aşama | Ne Yapar | Onay? |
|---|-------|----------|-------|
| 1 | Environment Check | Python, git, bash, PyYAML, ~/.claude/ varlık kontrolü | Hayır |
| 2 | State Inspection | Mevcut kurulum durumu, son manifest, önceki seçim | Hayır |
| 3 | Submodule Update Check | 16 submodule'u remote ile karşılaştırır | Hayır |
| 4 | Update Decision | Güncelleme varsa onay ister | ✅ Evet |
| 5 | Pull Submodules | `git submodule update --remote --merge` | Hayır (4'te onaylandı) |
| 6 | Extract Metadata | `extractor.py` — catalog.json oluşturur | Hayır |
| 7 | Score Components | `scorer_rubric.py` — scored-catalog.json | Hayır |
| 8 | Curate Selection | `curator.py` — selected.json | Hayır |
| 9 | Orchestrate + Budget + Validate | 3 ayrı script, lifecycle + budget + agent tree | Hayır |
| 10 | Install to ~/.claude/ | `installer.sh` — kurulum | ✅ Evet |
| 11 | Smoke Test | `smoke_test.sh` | Hayır |
| 12 | Git Commit + Push | decisions/ ve templates/ commit | ✅ Evet (2 kez) |

## İlk Çalıştırma

Fabrika ayarlarından gelen temiz sistemde:

```bash
bash scripts/setup.sh
```

Bu:
1. Çevreyi kontrol eder
2. Sources'daki tüm submodule'u tarar (ilk seferde dokunmaz)
3. Pipeline'ı baştan çalıştırır (~2-3 dakika)
4. "Install edilsin mi?" sorar → Evet dersen ~/.claude/'ya 2,388 component kurar
5. Smoke test çalıştırır
6. "Commit edelim mi?" sorar
7. "Push edelim mi?" sorar

## Düzenli Çalıştırma (Güncelleme)

```bash
# Haftalık kontrol
bash scripts/setup.sh
```

Bu:
1. Çevreyi kontrol eder
2. Her submodule için `git fetch` + behind sayısı bulur
3. Güncelleme yoksa → "Force re-run?" sorar (N varsayılan)
4. Güncelleme varsa → "Pull these updates?" sorar
5. Pull yapar, pipeline'ı yeniden çalıştırır
6. Diff'i gösterir (+/- kaç component değişti)
7. "Install edilsin mi?" sorar
8. Geri kalan akış aynı

## Cron Job Olarak

Haftalık otomatik çalıştırma:

```cron
# Pazar sabah 03:00'te auto mode'da çalıştır
0 3 * * 0 cd /c/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/setup.sh --auto >> /c/tmp/cloudcodecto-cron.log 2>&1
```

**Dikkat:** `--auto` mode onay sormaz, her şeyi yapar. Sadece güvendiğin bir state'te kullan.

## Log

Her çalıştırma `decisions/setup.log`'a yazılır:

```
[19:45:12] PHASE 1/12: Environment Check
[19:45:12] OK: Python 3.8.0
[19:45:13] OK: git 2.45.0
...
```

Önceki çalışmalar her run'da üzerine yazılır. Geçmiş istiyorsan `setup.log`'u manuel yedekle veya tracker.sh kullan.

## Çıkış Kodları

- `0` — Başarılı
- `1` — Abort (kullanıcı iptal, kritik hata, eksik dep)

## Dry-Run İpucu

Gerçek bir şey yapmadan ne olacağını görmek için:

```bash
bash scripts/setup.sh --dry-run
```

Bu:
- Submodule update çeker (`git fetch`) ama merge etmez
- `extractor.py` vs. çalıştırmaz
- Install etmez
- Commit etmez
- Sadece "şunu şunu yapacaktım" der

## Güvenlik

- **Backup:** install sırasında `/c/tmp/claude-install-backup-TS/` otomatik oluşturulur
- **Git güvenli:** Push'tan önce ayrı onay ister; force push asla yapmaz
- **Destructive ops:** install ve commit ayrı ayrı onaylanır

## Hata Durumunda

1. `decisions/setup.log`'a bak — son adım orada
2. Eğer install sırasında hata olduysa: backup'tan geri yükle:
   ```bash
   rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
   cp -r /c/tmp/claude-install-backup-YYYYMMDD-HHMMSS/. ~/.claude/
   ```
3. Eğer git commit'te sorun olduysa:
   ```bash
   git reset HEAD decisions/ templates/
   git checkout -- decisions/ templates/
   ```

## Self-Scoring Neden Otomatik Değil?

Self-scoring (Stage 3b) Claude Code'un Task tool'una ihtiyaç duyar — sadece Claude Code oturumu içinde çalışır, harici bash script'ten spawn edilemez. `setup.sh` yalnızca rubric skorlama yapar. Self-scoring istiyorsan:

1. Pipeline'ı bu script ile çalıştır
2. Sonra Claude Code'u aç
3. Manuel olarak isteğe göre self-scoring batch'lerini çalıştır (bkz: `scripts/prepare_self_scoring.py`)
4. `merge_self_scoring.py` sonuçları birleştirir
5. Pipeline'ı tekrar çalıştırmaya gerek yok (selected.json güncellenir)
