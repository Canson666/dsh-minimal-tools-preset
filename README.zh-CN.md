# DSH 智能体预设:极简 + 工具包 (Minimal + Toolkits)

> [English](./README.md) | **中文**

一个 [DeepSeek Harness](https://github.com/deepseek-ai/DeepSeekHarness)
智能体预设:**极简内核**(持久 bash + 文件编辑器、一行固定提示词、无运行时上下文快照、无压缩)之上按需挂载工具包——文件搜索、网页搜索、Skills、计划模式,以及一个 code-review 技能。

## 为什么

极简模式之所以快,是因为它几乎不组合任何东西:两个工具 + 极短提示词。标准模式则一次挂载全部。本预设保留极简内核,只添加你真正需要的工具包——比标准模式更快,比极简模式更能干。

## 包含的工具包

| 工具包 | 插件行 | 说明 |
| --- | --- | --- |
| 文件搜索 | `tool-fs`、`tool-fs-search` | read/edit/glob/grep |
| 网页搜索 | `tool-web` | 仅搜索,不带 fetch |
| Skills 技能 | `skill-filesystem`、`tool-skill` | 加载预设自带的 `skills/` 目录 |
| 计划模式 | `dsh-plan-mode`(isolated realm) | 先规划后执行的工作流 |
| 代码审查 | `skills/code-review` | 完成任务前自查 diff |

## 安装

预设 id 为 `minimal-tools`,必须放在
`${DSH_HOME:-$HOME/.dsh}/.agent-presets/minimal-tools/` 目录下。

### 方式 A:一键脚本

PowerShell(Windows):

```powershell
irm https://raw.githubusercontent.com/Canson666/dsh-minimal-tools-preset/main/install.ps1 | iex
```

或下载后本地运行:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Bash(macOS / Linux):

```bash
bash <(curl -sL https://raw.githubusercontent.com/Canson666/dsh-minimal-tools-preset/main/install.sh)
# 或本地运行:
bash install.sh
```

### 方式 B:手动复制

```bash
# 在仓库 checkout 目录下
mkdir -p "$HOME/.dsh/.agent-presets"
cp -r minimal-tools "$HOME/.dsh/.agent-presets/"
```

然后在 GUI **新建会话**,选择 **极简+工具包**。注意:**必须新建会话**——已打开的会话保留它启动时的组合(standing mount 按组合文件打戳,只有文件就位后新建的会话才会看到这些工具包,包括 `code-review`)。

## 验证

新会话中,技能列表应包含 `code-review`,工具列表应包含文件搜索、网页搜索和计划工具,以及极简内核的 `bash` + 编辑器。不开会话也可用命令验证:

```bash
dsh agent-presets standingKeyFor minimal-tools   # 必须能解析,无报错
```

## code-review 包如何工作

让 agent 审查它的改动(或说"完成前检查一下你的工作"),它会加载 `code-review` 技能:先取工作区 diff(`git status` / `git diff`),再在上下文中读改动代码,检查正确性 / 安全性 / 性能 / 一致性 / 错误路径,能修的就地修,最后给出带严重级别的结论。这是**自查版**——由改代码的同一个 agent 审查。更强力的"独立审查员"变体需要在组合中加入子代理包(`tool-subagent`);该行消费 host 的 `subagents` 注册表,不需要 realm。

## 兼容性

- 需要随 DeepSeek Harness 一起发布的 `minimal` 和 `standard` 预设(这里引用的 `@deepseek-ai/dsh-*` 插件行随 harness 发布)。
- Windows 和 Unix 均可用:`!!js` 技能根表达式相对预设自身目录(`baseUrl`)解析 `skills/`,因此从任何安装位置复制都能工作。

## 许可证

MIT
