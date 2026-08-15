# DSH Agent Preset: Minimal + Toolkits (极简 + 工具包)

> **English** | [中文](./README.zh-CN.md)

A [DeepSeek Harness](https://github.com/deepseek-ai/DeepSeekHarness) agent
preset: the **minimal** core (persistent bash + file editor, one-line fixed
prompt, no runtime-context snapshot, no compaction) plus **mountable tool
packs** — file search, web search, skills, plan mode, and a code-review skill.

## Why

`minimal` mode is fast because it composes almost nothing: two tools and a
tiny prompt. `standard` composes everything at once. This preset keeps the
minimal core and adds only the packs you actually want — better speed than
`standard`, more capability than `minimal`.

## Included packs

| Pack | Rows | Notes |
| --- | --- | --- |
| File search | `tool-fs`, `tool-fs-search` | read/edit/glob/grep |
| Web search | `tool-web` | search only, no fetch |
| Skills | `skill-filesystem`, `tool-skill` | loads the preset's own `skills/` |
| Plan mode | `dsh-plan-mode` (isolated realm) | plan-first workflow |
| Code review | `skills/code-review` | self-review your diff before finishing |

## Install

The preset id is `minimal-tools`; it must live at
`${DSH_HOME:-$HOME/.dsh}/.agent-presets/minimal-tools/`.

### Option A: one-command script

PowerShell (Windows):

```powershell
irm https://raw.githubusercontent.com/Canson666/dsh-minimal-tools-preset/main/install.ps1 | iex
```

or download and run locally:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Bash (macOS / Linux):

```bash
bash <(curl -sL https://raw.githubusercontent.com/Canson666/dsh-minimal-tools-preset/main/install.sh)
# or locally:
bash install.sh
```

### Option B: manual copy

```bash
# from a checkout of this repo
mkdir -p "$HOME/.dsh/.agent-presets"
cp -r minimal-tools "$HOME/.dsh/.agent-presets/"
```

Then start a **new** session in the GUI and pick **极简+工具包**. A new
session is required — a session already open keeps the composition it started
with (the standing mount is stamped per composition file, so only sessions
created after the files are in place see the packs, including `code-review`).

## Verify

In the new session, the skill list should include `code-review`, and the tool
list should show file-search, web-search, and plan tools alongside the minimal
`bash` + editor. To check without a session, run:

```bash
dsh agent-presets standingKeyFor minimal-tools   # must resolve, no error
```

## How the code-review pack works

Ask the agent to review its changes (or say "check your work before finishing"),
and it loads the `code-review` skill: it diffs the workspace (`git status` /
`git diff`), reads the changed code in context, checks correctness / security /
performance / consistency / error paths, fixes what it can, and reports a
severity-tagged verdict. This is the self-review variant — the same agent that
made the changes reviews them. A stronger "independent reviewer" variant needs
the subagent pack (`tool-subagent`) added to the composition; that row consumes
the host `subagents` registry and needs no realm.

## Compatibility

- Requires DeepSeek Harness with the shipped `minimal` and `standard` presets
  (the rows referenced here — `@deepseek-ai/dsh-*` — ship with the harness).
- Windows and Unix both work: the `!!js` skill-root expression resolves
  `skills/` relative to the preset's own directory (`baseUrl`), so the copy
  works from any install location.

## License

MIT
