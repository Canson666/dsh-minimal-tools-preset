# DSH Agent Preset: Minimal + Toolkits (极简 + 工具包)

A [DeepSeek Harness](https://github.com/deepseek-ai/DeepSeekHarness) agent
preset: the **minimal** core (persistent bash + file editor, one-line fixed
prompt, no runtime-context snapshot, no compaction) plus **mountable tool
packs** — file search, web search, skills, plan mode, and a code-review skill.

一个 DeepSeek Harness 智能体预设:**极简内核**(持久 bash + 文件编辑器、一行固定提示词、无运行时上下文快照、无压缩)之上按需挂载工具包——文件搜索、网页搜索、Skills、计划模式,以及一个 code-review 技能。

## Why (为什么)

`minimal` mode is fast because it composes almost nothing: two tools and a
tiny prompt. `standard` composes everything at once. This preset keeps the
minimal core and adds only the packs you actually want — better speed than
`standard`, more capability than `minimal`.

极简模式之所以快,是因为它几乎不组合任何东西:两个工具 + 极短提示词。标准模式则一次挂载全部。本预设保留极简内核,只添加你真正需要的工具包——比标准模式更快,比极简模式更能干。

## Included packs (包含的工具包)

| Pack | Rows | Notes |
| --- | --- | --- |
| File search 文件搜索 | `tool-fs`, `tool-fs-search` | read/edit/glob/grep |
| Web search 网页搜索 | `tool-web` | search only, no fetch |
| Skills 技能 | `skill-filesystem`, `tool-skill` | loads the preset's own `skills/` |
| Plan mode 计划模式 | `dsh-plan-mode` (isolated realm) | plan-first workflow |
| Code review 代码审查 | `skills/code-review` | self-review your diff before finishing |

## Install (安装)

The preset id is `minimal-tools`; it must live at
`${DSH_HOME:-$HOME/.dsh}/.agent-presets/minimal-tools/`.

预设 id 为 `minimal-tools`,必须放在
`${DSH_HOME:-$HOME/.dsh}/.agent-presets/minimal-tools/` 目录下。

### Option A: one-command script (一键脚本)

PowerShell (Windows):

```powershell
irm https://raw.githubusercontent.com/<you>/<repo>/main/install.ps1 | iex
```

or download and run locally:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Bash (macOS / Linux):

```bash
bash <(curl -sL https://raw.githubusercontent.com/<you>/<repo>/main/install.sh)
# or locally:
bash install.sh
```

### Option B: manual copy (手动复制)

```bash
# from a checkout of this repo
mkdir -p "$HOME/.dsh/.agent-presets"
cp -r minimal-tools "$HOME/.dsh/.agent-presets/"
```

Then start a new session in the GUI and pick **极简+工具包**. A new session
is required — a session already open keeps the composition it started with
(the standing mount is stamped per composition file, so only sessions created
after the files are in place see the packs, including `code-review`).

然后在 GUI 新建会话,选择 **极简+工具包**。注意:**必须新建会话**——已打开的会话保留它启动时的组合(standing mount 按组合文件打戳,只有文件就位后新建的会话才会看到这些工具包,包括 `code-review`)。

## Verify (验证)

In the new session, the skill list should include `code-review`, and the tool
list should show file-search, web-search, and plan tools alongside the minimal
`bash` + editor. To check without a session, run:

```bash
dsh agent-presets standingKeyFor minimal-tools   # must resolve, no error
```

## How the code-review pack works (code-review 包如何工作)

Ask the agent to review its changes (or say "check your work before finishing"),
and it loads the `code-review` skill: it diffs the workspace (`git status` /
`git diff`), reads the changed code in context, checks correctness / security /
performance / consistency / error paths, fixes what it can, and reports a
severity-tagged verdict. This is the self-review variant — the same agent that
made the changes reviews them. A stronger "independent reviewer" variant needs
the subagent pack (`tool-subagent`) added to the composition; that row consumes
the host `subagents` registry and needs no realm.

## Compatibility (兼容性)

- Requires DeepSeek Harness with the shipped `minimal` and `standard` presets
  (the rows referenced here — `@deepseek-ai/dsh-*` — ship with the harness).
- Windows and Unix both work: the `!!js` skill-root expression resolves
  `skills/` relative to the preset's own directory (`baseUrl`), so the copy
  works from any install location.

## License

MIT
