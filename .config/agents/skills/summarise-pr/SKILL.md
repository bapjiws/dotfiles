---
name: summarise-pr
description: Use when the user asks to summarise or summarize the current PR, the current branch's changes, or "this diff" — phrases like "summarise this PR", "summarize the PR", "summarise the diff", "summarize my changes", or "/summarise-pr".
---

# Summarise PR

## Overview
Produces a brief, scannable summary of the changes in the current PR (or current branch, if no PR is open yet), delivered as raw markdown source in a fenced code block so it can be pasted verbatim into a GitHub PR description, Slack message, or changelog — not rendered as chat output.

## When to Use
Triggers: "summarise this PR", "summarize the PR", "summarise the diff", "summarize my changes", or `/summarise-pr`.

## Steps
1. Confirm you're in a git repo: `git rev-parse --is-inside-work-tree` — if this fails, tell the user there's no git repository here and stop.
2. Determine the source of changes, in this order:
   - **Open PR for the current branch** (preferred): if `gh` is installed (`command -v gh`), check for a PR:
     ```bash
     gh pr view --json number,title,url,body 2>/dev/null
     ```
     If this succeeds, pull its stat and diff:
     ```bash
     gh pr diff --stat
     gh pr diff
     ```
   - **`gh` installed but no open PR yet**: diff against the repo's actual default branch — don't assume `main`:
     ```bash
     base=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
     git fetch origin "$base" --quiet
     git diff --stat "origin/$base...HEAD"
     git diff "origin/$base...HEAD"
     git log --oneline "origin/$base..HEAD"
     ```
   - **No `gh` CLI at all**: fall back to git-only default-branch detection:
     ```bash
     base=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
     [ -z "$base" ] && base=$(git rev-parse --verify origin/main >/dev/null 2>&1 && echo main || echo master)
     git diff --stat "origin/$base...HEAD"
     git diff "origin/$base...HEAD"
     git log --oneline "origin/$base..HEAD"
     ```
     Mention in the summary that this is a local diff, not PR metadata — no title/URL/description is available in this path.
3. If the diff is empty, tell the user there's nothing to summarise (relative to the PR / base branch) and stop — don't fabricate a summary.
4. If the diff is large (rule of thumb: `--stat` lists more than ~15 files, or the full patch is too big to read comfortably), work from the `--stat` file list and commit log instead of the full patch text. Only pull a full diff for individual files (`git diff <base>...HEAD -- <path>`) when the file list alone doesn't make the change clear.
5. Synthesize, don't transcribe. If the branch/PR has multiple unrelated commits, group the summary by theme or area (e.g. "Auth", "CI", "Docs") instead of listing commit-by-commit or file-by-file. Use commit messages and the PR title/body (if any) as signal for *why*, not just *what*.
6. Write the summary as markdown:
   - One-line title (PR title if available, otherwise a short description of the change).
   - 3-8 bullets, one line each, covering only the meaningful changes — skip trivial diffs (formatting-only files, lockfile bumps) unless that's literally the whole PR.
   - Group bullets under short `##`/`###` headers only if the change genuinely spans distinct areas; prefer a flat bullet list otherwise.
7. Output the markdown wrapped in a fenced code block, language-tagged `markdown`, with nothing else of substance outside it (at most one short lead-in sentence). This keeps the markdown as literal, unrendered source — sending it as normal chat prose would let Claude Code's own rendering swallow the `##`/`-` syntax before the user can copy it.

## Common Mistakes
- Rendering the summary as normal chat markdown instead of fencing it in a fenced `markdown` block — the user loses the literal `##`/`-` syntax and can't paste it as-is.
- Assuming the default branch is `main` — detect it (`gh repo view` or `git symbolic-ref refs/remotes/origin/HEAD`), since it may be `master` or something else.
- Pulling the full `git diff`/`gh pr diff` patch text for a large PR — use `--stat` plus targeted per-file diffs instead of flooding context with the whole patch.
- Listing every commit or every changed file — synthesize by theme instead; a PR with a dozen commits should still read as one coherent summary.
- Producing a summary when the diff is empty — say there's nothing to summarise instead of inventing content.
- Treating a failed `gh pr view` as an error to surface — it just means no PR is open yet; fall back to the branch diff silently.
