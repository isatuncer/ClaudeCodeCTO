# CloaudeCodeCTO

> **语言:** [English](../../README.md) · [Türkçe](../../README.tr.md) · [Deutsch](README.de.md) · [Español](README.es.md) · [Français](README.fr.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · **中文** · [Русский](README.ru.md) · [العربية](README.ar.md)

> 将 Claude Code 转变为全生命周期 CTO:从 14 个顶级开源代码库中精选 2,388 个技能、代理和命令,零外部成本安装到 `~/.claude/`。

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-2388-green.svg)](../../decisions/selected.json)

---

## 这是什么?

CloaudeCodeCTO 是一个**策划和安装系统**,它从 14 个公共 Claude Code 代码库中获取最佳的技能、代理和命令,并将它们作为一个统一的工具包安装到您的 `~/.claude/` 目录中。

结果:一个可以指导您**从想法到生产**的 Claude Code 安装 — 通过发现、规划、设计、构建、测试、文档、发布和维护 — 在每个阶段使用专门的代理。

把它想象成为您的项目雇用一个 CTO:一个已经了解每个框架、每个测试策略、每个部署模式,并且准确知道在每一步调用哪个专家的人。

---

## 快速开始 — 一个命令

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

或使用 `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

默认目标目录是 `$HOME/CloaudeCodeCTO`。要覆盖:

```bash
CCCTO_DIR=/custom/path bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### 手动开始

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### 环境变量

| 变量 | 默认值 | 说明 |
|---|---|---|
| `CCCTO_DIR` | `$HOME/CloaudeCodeCTO` | 目标克隆目录 |
| `CCCTO_BRANCH` | `main` | 要克隆的分支 |
| `CCCTO_AUTO` | `0` | `1` = 非交互模式 |
| `CCCTO_NO_INSTALL` | `0` | `1` = 跳过 `~/.claude/` 安装 |

---

## 特性

- **2,388 个组件** — 从 14 个代码库精选的 1,845 个技能 + 307 个代理 + 236 个命令
- **8 阶段生命周期** — 发现 → 规划 → 设计 → 构建 → 测试 → 文档 → 发布 → 维护
- **零外部成本** — 无 Anthropic API 调用,无付费服务,无遥测
- **工厂重置兼容** — 在干净的 `~/.claude/` 上工作,保留 `.credentials.json`
- **带备份的原子安装** — 所有内容首先在 `/c/tmp/` 中暂存,然后提交
- **默认交互式** — 确认每个破坏性操作;CI 使用 `--auto`
- **可恢复** — 流水线阶段写入 `decisions/`,可以从任何检查点重新启动
- **单一事实来源** — 只有 `decisions/` 是权威的;没有隐藏的配置
- **Windows + Linux + macOS** — 路径感知(Windows 上使用 `cygpath`)

---

## 安装的内容

```
~/.claude/
├── .credentials.json              (保留)
├── CLAUDE.md                      全局指令(生成)
├── settings.json                  harness 配置(生成)
├── skills/                        1,845 个技能
│   └── project-lifecycle/         元编排器(8 阶段)
├── agents/                        307 个专业代理
├── commands/                      236 个斜杠命令
│   └── start-project.md           /start-project 生命周期入口
├── rules/
│   └── agent-decision-tree.md     哪个代理用于哪个任务
└── config/
    └── lifecycle.json             8 阶段项目地图
```

**按领域细分:**

| 领域 | 数量 | 示例 |
|---|---:|---|
| devops | 541 | docker、kubernetes、terraform、CI/CD |
| project-mgmt | 349 | 计划、OKR、Sprint 工作流 |
| frontend | 333 | React、Vue、Next.js、设计系统 |
| coding | 287 | 语言特定的构建器和审查器 |
| backend | 183 | API、数据库、微服务 |
| security | 143 | 审计、渗透测试、合规 |
| testing | 140 | 单元、集成、E2E、变异 |
| data-ai | 132 | ML 流水线、LLM 集成、RAG |
| docs | 120 | 技术写作、API 参考 |
| architecture | 81 | C4 图、ADR、系统设计 |
| other | 79 | 其他 |

在任何更改之前,之前的 `~/.claude/` 的备份会自动保存到 `/c/tmp/claude-install-backup-<timestamp>/`。

---

## 8 阶段项目生命周期

安装后,在新的 Claude Code 会话中运行 `/start-project` 会激活生命周期编排器。

| 阶段 | 名称 | 座右铭 | 主要代理 |
|---|---|---|---|
| 1 | Discovery | "是什么,为什么?" | business-analyst, market-researcher, ux-researcher |
| 2 | Planning | "怎么构建?" | planner, architect, product-manager |
| 3 | Design | "看起来是什么样?" | ui-designer, api-designer, database-architect |
| 4 | Build | "写代码" | fullstack/frontend/backend-developer, tdd-guide |
| 5 | Test | "工作正常吗?" | test-automator, qa-expert, e2e-runner |
| 6 | Document | "怎么使用?" | technical-writer, api-documenter |
| 7 | Ship | "怎么上线?" | deployment-engineer, devops-engineer, sre-engineer |
| 8 | Maintain | "怎么保持健康?" | performance-engineer, security-engineer, refactor-cleaner |

每个阶段都是可恢复的。如果您关闭会话,`decisions/project-state.json` 会记住您的位置。

---

## 策划流水线

9 阶段流水线构建 `decisions/selected.json`。它只在维护者的机器上运行 — 最终用户永远不会看到。

```
1. DISCOVER     原始组件的 TSV 清单
2. EXTRACT      带丰富元数据的 catalog.json
3a. SCORE       100 分确定性评分标准
3b. SELF-SCORE  通过 Claude Code 子代理进行语义评分
4. CURATE       去重 + 领域分组 → selected.json
4.5 ORCHESTRATE 8 阶段生命周期绑定
4.6 BUDGET      token 成本配置文件(~105K 启动)
4.7 VALIDATE    22 个重叠对 → 决策树
5. INSTALL      原子暂存安装 + 备份
5.5 SMOKE TEST  8 测试结构验证
6. OPTIMIZE     基于使用的修剪(可选)
```

### 100 分评分标准

| 维度 | 分数 | 衡量内容 |
|---|---:|---|
| 结构 | 30 | 有效的 YAML frontmatter、必需字段、大小合理 |
| 内容 | 30 | 描述长度、示例、清晰的触发条件 |
| 跨代码库 | 20 | 代码库之间的唯一性、新鲜度 |
| 领域匹配 | 20 | 优先领域奖励 |

---

## 源代码库

14 个活跃的子模块。所有许可证都保留在各自的目录中。

| 代码库 | 重点 | Skills | Agents | Commands |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | 官方 Anthropic 技能 | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | 一体化工具包 | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | 大型技能集合 | 1,404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | 领域专家 | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | 策划的子代理 | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | 完整工具包 | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | 持续开发工作流 | 156 | 32 | 0 |

完整列表在 [`.gitmodules`](../../.gitmodules) 中。

---

## 要求

- **Claude Code** 已安装,凭据位于 `~/.claude/.credentials.json`
- **Python 3.8+** 和 `PyYAML`(由 `install.sh` 自动安装)
- **Bash** 4+(Windows 上的 git-bash)
- **Git** 带子模块支持
- **~1 GB 可用磁盘空间**用于子模块 + 生成的工件
- **~5–15 分钟**初始设置

支持的平台: Windows (git-bash)、macOS、Linux。

---

## 故障排除

### 设置在 "Environment Check" 失败

```bash
pip install pyyaml
```

### 子模块拉取失败

```bash
git submodule sync
git submodule update --init --recursive --force
```

### 安装中途失败

备份在 `/c/tmp/claude-install-backup-<timestamp>/`。恢复:

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code 看不到新技能

启动一个**新的 Claude Code 会话**。系统提示在会话开始时冻结。

---

## 常见问题

**问: 为什么是"零成本"?Claude Code 使用我的 API 积分,对吧?**
是的 — Claude Code 使用您现有的会话。"零成本"指的是这个流水线:没有单独的 Anthropic API 密钥,没有第三方服务,没有付费评分。

**问: 它会覆盖我现有的 `~/.claude/` 吗?**
不会 — 安装程序首先将所有内容备份到 `/c/tmp/claude-install-backup-<timestamp>/`,然后将新安装暂存到 `/c/tmp/claude-install-stage-<timestamp>/`,然后复制文件。如果出现问题,您可以从备份目录恢复。

**问: 我可以选择安装哪些组件吗?**
可以 — 在运行 `setup.sh` 之前编辑 `decisions/selected.json`。

**问: 加载 1,845 个技能的 token 成本是多少?**
会话启动时约 **105K tokens**。大多数技能在触发时延迟加载。

---

## 许可证

MIT — 参见 [LICENSE](../../LICENSE)。

## 致谢

本项目策划来自 14 个开源代码库的内容。完整列表见 [`.gitmodules`](../../.gitmodules)。所有子模块许可证都保留在各自的 `sources/<repo>/` 目录中。

由 [@isatuncer](https://github.com/isatuncer) 构建。欢迎 PR 和 issue。
