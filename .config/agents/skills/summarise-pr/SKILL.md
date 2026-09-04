---
name: summarise-pr
description: Use when the user asks to summarise or summarize the current PR, the current branch's changes, or "this diff" — phrases like "summarise this PR", "summarize the PR", "summarise the diff", "summarize my changes", or "/summarise-pr".
---

# Summarise PR

## Overview
Produces a brief, scannable summary of the changes in the current PR (or current branch, if no PR is open yet), copies it to the clipboard, and shows it as raw markdown source in a fenced code block — ready to paste directly into a GitHub PR description (⌘V), Slack message, or changelog, not rendered as chat output.

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
3. Ask the user directly — a single yes/no question, before composing the summary — whether this is a "P+" project. This decides whether a ticket-link section gets added; don't infer it yourself from the title's shape (a parenthetical doesn't necessarily mean P+).
   - **If yes**: extract the ticket ID from the PR title's trailing parenthetical — a short token of letters/digits with a hyphen, no spaces, e.g. `feat: intro page sections (P30300115-6100)` → `P30300115-6100`. If the title has no such parenthetical (or there's no PR title at all), tell the user and ask them to supply the ID directly instead of guessing.
   - **If no**: don't extract or ask for an ID at all — there will be no `## Link to ticket` section.
4. If the diff is empty, tell the user there's nothing to summarise (relative to the PR / base branch) and stop — don't fabricate a summary.
5. If the diff is large (rule of thumb: `--stat` lists more than ~15 files, or the full patch is too big to read comfortably), work from the `--stat` file list and commit log instead of the full patch text. Only pull a full diff for individual files (`git diff <base>...HEAD -- <path>`) when the file list alone doesn't make the change clear.
6. Synthesize, don't transcribe. If the branch/PR has multiple unrelated commits, group the summary by theme or area (e.g. "Auth", "CI", "Docs") instead of listing commit-by-commit or file-by-file. Use commit messages and the PR title/body (if any) as signal for *why*, not just *what*.
7. Write the summary as markdown:
   - `## Changes` — a fixed, literal section header (never the raw PR title text) — followed by 3-8 bullets, one line each, covering only the meaningful changes — skip trivial diffs (formatting-only files, lockfile bumps) unless that's literally the whole PR.
   - Group bullets under short `###` sub-headers only if the change genuinely spans distinct areas; prefer a flat bullet list otherwise.
   - Only if step 3 was answered yes, add a second section, `## Link to ticket`, containing just the bare ID (found or supplied in step 3) on its own line — no markdown link syntax, no guessed URL. GitHub's "autolink references" feature (the same thing that renders the ID as a link in the PR title itself) auto-links the bare ID once it's pasted into a PR description, so constructing a URL yourself would just risk guessing wrong.
   - Otherwise omit the `## Link to ticket` section entirely — don't leave it in empty.
8. Copy the markdown to the clipboard so it's one ⌘V away from pasting into GitHub, using a **quoted** heredoc (`<<'EOF'`) so the shell doesn't expand `$`, backticks, or other special characters that might appear in commit messages or file paths:
   ```bash
   pbcopy <<'EOF'
   ## Changes
   - <bullet>
   - <bullet>

   ## Link to ticket
   <ID>
   EOF
   ```
9. Output the identical markdown in the chat, wrapped in a fenced code block language-tagged `markdown`, with a short lead-in noting it's already on the clipboard — nothing else of substance outside the block. This keeps the markdown as literal, unrendered source — sending it as normal chat prose would let Claude Code's own rendering swallow the `##`/`-` syntax before the user can copy it.

## Common Mistakes
- Rendering the summary as normal chat markdown instead of fencing it in a fenced `markdown` block — the user loses the literal `##`/`-` syntax and can't paste it as-is.
- Copy-pasting the raw PR title as the section header instead of the fixed `## Changes` label.
- Auto-detecting a ticket ID from the title's shape and skipping the P+ question — always ask; a parenthetical alone isn't confirmation this is a P+ project.
- Constructing a guessed Atlassian/Jira URL for the ticket ID instead of pasting the bare ID — let GitHub's autolink reference (the same one that links it in the PR title) do the linking.
- Including an empty `## Link to ticket` section when the answer was no, or when yes but no ID could be found or supplied — omit the section entirely instead.
- Using an unquoted heredoc (`<<EOF` instead of `<<'EOF'`) with `pbcopy` — lets the shell expand `$`/backticks inside commit messages or filenames before they hit the clipboard.
- Letting the clipboard content and the chat-displayed content drift apart — copy and display the exact same markdown.
- Assuming the default branch is `main` — detect it (`gh repo view` or `git symbolic-ref refs/remotes/origin/HEAD`), since it may be `master` or something else.
- Pulling the full `git diff`/`gh pr diff` patch text for a large PR — use `--stat` plus targeted per-file diffs instead of flooding context with the whole patch.
- Listing every commit or every changed file — synthesize by theme instead; a PR with a dozen commits should still read as one coherent summary.
- Producing a summary when the diff is empty — say there's nothing to summarise instead of inventing content.
- Treating a failed `gh pr view` as an error to surface — it just means no PR is open yet; fall back to the branch diff silently.
