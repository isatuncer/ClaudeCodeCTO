# CloaudeCodeCTO

> **言語:** [English](../../README.md) · [Türkçe](../../README.tr.md) · [Deutsch](README.de.md) · [Español](README.es.md) · [Français](README.fr.md) · **日本語** · [한국어](README.ko.md) · [中文](README.zh-CN.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

> Claude Code を完全ライフサイクル CTO に変える:14 のトップオープンソースリポジトリから厳選された 2,388 のスキル、エージェント、コマンドを、外部コストゼロで `~/.claude/` にインストール。

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-2388-green.svg)](../../decisions/selected.json)

---

## これは何ですか?

CloaudeCodeCTO は、14 の公開 Claude Code リポジトリから最高のスキル、エージェント、コマンドを取得し、統一されたツールキットとして `~/.claude/` ディレクトリにインストールする**キュレーションおよびインストールシステム**です。

結果:アイデアから本番環境までガイドしてくれる Claude Code インストール — Discovery、Planning、Design、Build、Test、ドキュメント化、Shipping、メンテナンスを通じて、各フェーズで目的別のエージェントを使用します。

プロジェクトに CTO を雇うようなものと考えてください:すべてのフレームワーク、すべてのテスト戦略、すべてのデプロイメントパターンを既に知っており、各ステップでどのスペシャリストを呼び出すべきかを正確に知っている人です。

---

## クイックスタート — ワンコマンド

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

または `wget` で:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

デフォルトのターゲットディレクトリは `$HOME/CloaudeCodeCTO` です。上書きするには:

```bash
CCCTO_DIR=/custom/path bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### 手動スタート

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### 環境変数

| 変数 | デフォルト | 説明 |
|---|---|---|
| `CCCTO_DIR` | `$HOME/CloaudeCodeCTO` | クローン先ディレクトリ |
| `CCCTO_BRANCH` | `main` | クローンするブランチ |
| `CCCTO_AUTO` | `0` | `1` = 非対話モード |
| `CCCTO_NO_INSTALL` | `0` | `1` = `~/.claude/` インストールをスキップ |

---

## 機能

- **2,388 コンポーネント** — 14 リポジトリからキュレーションされた 1,845 スキル + 307 エージェント + 236 コマンド
- **8 フェーズライフサイクル** — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **外部コストゼロ** — Anthropic API 呼び出しなし、有料サービスなし、テレメトリなし
- **ファクトリーリセット対応** — クリーンな `~/.claude/` で動作し、`.credentials.json` を保持
- **バックアップ付きアトミックインストール** — まず `/c/tmp/` でステージング、その後コミット
- **デフォルトで対話的** — すべての破壊的アクションを確認、CI には `--auto`
- **再開可能** — パイプラインステージは `decisions/` に書き込み、任意のチェックポイントから再開可能
- **信頼できる唯一の情報源** — `decisions/` のみが権威であり、隠された設定はなし
- **Windows + Linux + macOS** — パス対応(Windows では `cygpath` を使用)

---

## インストールされるもの

```
~/.claude/
├── .credentials.json              (保持される)
├── CLAUDE.md                      グローバル指示(生成)
├── settings.json                  ハーネス設定(生成)
├── skills/                        1,845 スキル
│   └── project-lifecycle/         メタオーケストレーター(8 フェーズ)
├── agents/                        307 の専門エージェント
├── commands/                      236 スラッシュコマンド
│   └── start-project.md           /start-project ライフサイクルエントリ
├── rules/
│   └── agent-decision-tree.md     どのタスクにどのエージェント
└── config/
    └── lifecycle.json             8 フェーズプロジェクトマップ
```

**ドメイン別内訳:**

| ドメイン | 数 | 例 |
|---|---:|---|
| devops | 541 | docker、kubernetes、terraform、CI/CD |
| project-mgmt | 349 | プランニング、OKR、スプリントワークフロー |
| frontend | 333 | React、Vue、Next.js、デザインシステム |
| coding | 287 | 言語固有のビルダーとレビュアー |
| backend | 183 | API、データベース、マイクロサービス |
| security | 143 | 監査、ペネトレーションテスト、コンプライアンス |
| testing | 140 | ユニット、統合、E2E、ミューテーション |
| data-ai | 132 | ML パイプライン、LLM 統合、RAG |
| docs | 120 | テクニカルライティング、API リファレンス |
| architecture | 81 | C4 ダイアグラム、ADR、システム設計 |
| other | 79 | その他 |

変更前に、以前の `~/.claude/` のバックアップが自動的に `/c/tmp/claude-install-backup-<timestamp>/` に保存されます。

---

## 8 フェーズのプロジェクトライフサイクル

インストール後、新しい Claude Code セッションで `/start-project` を実行すると、ライフサイクルオーケストレーターが起動します。

| フェーズ | 名前 | モットー | 主要エージェント |
|---|---|---|---|
| 1 | Discovery | "何を、なぜ?" | business-analyst、market-researcher、ux-researcher |
| 2 | Planning | "どう構築する?" | planner、architect、product-manager |
| 3 | Design | "どう見える?" | ui-designer、api-designer、database-architect |
| 4 | Build | "コードを書く" | fullstack/frontend/backend-developer、tdd-guide |
| 5 | Test | "動作する?" | test-automator、qa-expert、e2e-runner |
| 6 | Document | "どう使う?" | technical-writer、api-documenter |
| 7 | Ship | "本番にどう出す?" | deployment-engineer、devops-engineer、sre-engineer |
| 8 | Maintain | "健全性をどう保つ?" | performance-engineer、security-engineer、refactor-cleaner |

各フェーズは再開可能です。セッションを閉じた場合、`decisions/project-state.json` がどこにいたかを記憶します。

---

## キュレーションパイプライン

9 段階のパイプラインが `decisions/selected.json` を構築します。メンテナのマシンでのみ実行され、エンドユーザーは見ることはありません。

```
1. DISCOVER     生コンポーネントの TSV インベントリ
2. EXTRACT      リッチメタデータを含む catalog.json
3a. SCORE       100 ポイントの決定論的ルーブリック
3b. SELF-SCORE  Claude Code サブエージェントによるセマンティックスコアリング
4. CURATE       dedupe + ドメイングルーピング → selected.json
4.5 ORCHESTRATE 8 フェーズライフサイクルバインディング
4.6 BUDGET      トークンコストプロファイル(~105K 起動時)
4.7 VALIDATE    22 のオーバーラップペア → 決定木
5. INSTALL      アトミックステージングインストール + バックアップ
5.5 SMOKE TEST  8 テストの構造検証
6. OPTIMIZE     使用ベースのプルーニング(オプション)
```

### 100 ポイントルーブリック

| 次元 | ポイント | 測定するもの |
|---|---:|---|
| 構造的 | 30 | 有効な YAML フロントマター、必須フィールド、サイズの健全性 |
| コンテンツ | 30 | 説明の長さ、例、明確なトリガー条件 |
| クロスリポジトリ | 20 | リポジトリ間の一意性、鮮度 |
| ドメイン適合性 | 20 | 優先ドメインボーナス |

---

## ソースリポジトリ

14 のアクティブなサブモジュール。すべてのライセンスは各ディレクトリに保持されます。

| リポジトリ | フォーカス | Skills | Agents | Commands |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | 公式 Anthropic スキル | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | オールインワンツールキット | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | 巨大なスキルコレクション | 1,404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | ドメインスペシャリスト | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | キュレーションされたサブエージェント | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | フルツールキット | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | 継続的開発ワークフロー | 156 | 32 | 0 |

完全なリストは [`.gitmodules`](../../.gitmodules) にあります。

---

## 要件

- **Claude Code** が `~/.claude/.credentials.json` の認証情報付きでインストール済み
- **Python 3.8+** と `PyYAML`(`install.sh` により自動インストール)
- **Bash** 4+(Windows では git-bash)
- **Git** とサブモジュールサポート
- **~1 GB の空きディスク** サブモジュール + 生成されたアーティファクト用
- **~5–15 分** 初回セットアップ

サポートプラットフォーム: Windows (git-bash)、macOS、Linux。

---

## トラブルシューティング

### セットアップが "Environment Check" で失敗

```bash
pip install pyyaml
```

### サブモジュールのプルが失敗

```bash
git submodule sync
git submodule update --init --recursive --force
```

### インストールが途中で失敗

バックアップは `/c/tmp/claude-install-backup-<timestamp>/` にあります。復元するには:

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code が新しいスキルを認識しない

**新しい Claude Code セッション**を開始してください。システムプロンプトはセッション開始時に凍結されます。

---

## FAQ

**Q: なぜ「コストゼロ」なのですか?Claude Code は私の API クレジットを使いますよね?**
はい — Claude Code は既存のセッションを使用します。「コストゼロ」とはこのパイプラインのことです:別個の Anthropic API キーなし、サードパーティサービスなし、有料スコアリングなし。

**Q: 既存の `~/.claude/` を上書きしますか?**
いいえ — インストーラーは最初にすべてを `/c/tmp/claude-install-backup-<timestamp>/` にバックアップし、次に新しいインストールを `/c/tmp/claude-install-stage-<timestamp>/` にステージングし、その後ファイルをコピーします。何か問題が発生した場合は、バックアップディレクトリから復元できます。

**Q: インストールするコンポーネントを選択できますか?**
はい — `setup.sh` を実行する前に `decisions/selected.json` を編集してください。

**Q: 1,845 のスキルをロードするトークンコストはどのくらいですか?**
セッション開始時に約 **105K トークン**。ほとんどのスキルはトリガーされたときに遅延ロードされます。

---

## ライセンス

MIT — [LICENSE](../../LICENSE) を参照。

## 謝辞

このプロジェクトは 14 のオープンソースリポジトリからコンテンツをキュレーションします。完全なリストは [`.gitmodules`](../../.gitmodules) を参照してください。すべてのサブモジュールライセンスは、それぞれの `sources/<repo>/` ディレクトリに保持されています。

[@isatuncer](https://github.com/isatuncer) によって構築されました。PR と issue は歓迎します。
