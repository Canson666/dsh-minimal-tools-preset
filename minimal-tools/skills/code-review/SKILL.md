---
name: code-review
description: Review code changes before finishing. Use when the user asks to review changes, check work, self-review, or when a task that changed files is about to conclude — review the diff, find bugs/security/performance/consistency issues, and report a verdict. Also use after completing edits to multiple files in one task.
---

# Code review

Review the work you just did (or the work in the current workspace) like an
independent senior engineer. The goal is to catch real problems before the
user does — not to rubber-stamp your own changes.

## When to use

- The user asked you to review your work, or asked "did you check everything?".
- You are about to finish a task that modified files.
- You are asked to review a diff, a branch, or someone else's changes in the
  workspace.

## Procedure

1. **Establish the diff.** Prefer `git` when the workspace is a repository:
   - `git status --porcelain` — what changed (staged and unstaged).
   - `git diff` for unstaged changes; add `--staged` for staged ones; use
     `git diff HEAD` when you want everything since the last commit.
   - If the workspace is not a git repository, review the files you actually
     created or edited this session instead (you know which those are).
   - If the diff is huge, review it in chunks: per-file diffs, then the
     cross-cutting concerns below.
2. **Read the changed code in context.** A diff alone hides surrounding
   invariants. Open each changed file around its hunks and check:
   - the change is coherent with the file's existing patterns and types;
   - no caller/callee was missed (renames, signature changes, moved code);
   - error paths are handled and cleanup actually runs.
3. **Check the cross-cutting concerns:**
   - **Correctness** — off-by-one, wrong branch, missing null/undefined
     guard, stale assumptions, races.
   - **Security** — path traversal, injection, unsafe deserialization,
     secrets hard-coded or logged, overly permissive sandbox/approval usage,
     commands run with data-derived arguments.
   - **Performance** — accidental O(n²), repeated work in loops, unbounded
     output, huge files written to the context.
   - **Consistency** — naming, formatting, duplicate logic, dead code,
     leftover debug prints, TODOs that the task actually required.
4. **Fix what you can, report what you cannot.** You are still the agent that
   made the changes: fix clear bugs yourself, then re-check the fix. If a
   concern needs a human decision or is out of scope, say so explicitly.
5. **Report.** Summarize: what you reviewed (scope of diff), issues found
   (severity-tagged), what you fixed, what remains, and an overall verdict
   (approved / approved with nits / needs follow-up).

## Tone

Be honest and concrete. One verified defect is worth more than ten vague
"could be improved" notes. If nothing is wrong, say so plainly with the checks
you ran — an empty review is only credible when it names what was examined.
