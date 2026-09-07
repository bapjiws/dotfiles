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
3. Ask the user directly — a single yes/no question, before composing the summary — whether this is a "P+" project. This decides whether a ticket-link section AND a testing section get added; don't infer it yourself from the title's shape (a parenthetical doesn't necessarily mean P+).
   - **If yes**, gather all three of the following before moving on:
     a. **Ticket ID**: extract it from the PR title's trailing parenthetical — a short token of letters/digits with a hyphen, no spaces, e.g. `feat: intro page sections (P30300115-6100)` → `P30300115-6100`. If the title has no such parenthetical (or there's no PR title at all), ask the user to supply the ID directly instead of guessing.
     b. **Test environment**: two steps — one clickable pick, one typed answer:
        1. `AskUserQuestion` with exactly two options, `accept` and `pplus` — nothing more (this is the only part that's a clickable pick; two options fits comfortably under the 4-option cap that `accept1`-`pplus9` all at once, or even a 9-way `pplus` split, would hard-reject).
        2. Then, as a plain chat question, ask for the number — mention the valid range for whichever family they picked (`accept` is 1-3, `pplus` is 1-9) — and let them type it.

        Compose the final environment string as `<family><number>` (e.g. `accept2`, `pplus7`).
     c. **Test user ID**: unlike (b), ask this as a plain chat question, not `AskUserQuestion` — it's open-ended text (a "P-number", e.g. `P-00107912`), and that tool needs real clickable options rather than a text box. Let the user paste it in verbatim — don't reuse the ticket ID from (a), it's a different value.
   - **If no**: skip all three — no ticket ID, no environment, no user ID, and no `## Link to ticket` or `## Testing` section.
4. If the diff is empty, tell the user there's nothing to summarise (relative to the PR / base branch) and stop — don't fabricate a summary.
5. If the diff is large (rule of thumb: `--stat` lists more than ~15 files, or the full patch is too big to read comfortably), work from the `--stat` file list and commit log instead of the full patch text. Only pull a full diff for individual files (`git diff <base>...HEAD -- <path>`) when the file list alone doesn't make the change clear.
6. Synthesize, don't transcribe. If the branch/PR has multiple unrelated commits, group the summary by theme or area (e.g. "Auth", "CI", "Docs") instead of listing commit-by-commit or file-by-file. Use commit messages and the PR title/body (if any) as signal for *why*, not just *what*.
7. Write the summary as markdown:
   - `## Changes` — a fixed, literal section header (never the raw PR title text) — followed by 3-8 bullets, one line each, covering only the meaningful changes — skip trivial diffs (formatting-only files, lockfile bumps) unless that's literally the whole PR.
   - Group bullets under short `###` sub-headers only if the change genuinely spans distinct areas; prefer a flat bullet list otherwise.
   - Only if step 3 was answered yes, also add:
     - `## Link to ticket`, containing just the bare ticket ID (found or supplied in step 3a) on its own line — no markdown link syntax, no guessed URL. GitHub's "autolink references" feature (the same thing that renders the ID as a link in the PR title itself) auto-links the bare ID once it's pasted into a PR description, so constructing a URL yourself would just risk guessing wrong.
     - `## Testing`, containing exactly one line in this shape: `` On `<environment>` with `<user P-number>`. `` — using the environment (3b) and user ID (3c) gathered in step 3, both as inline code spans, ending with a period.
   - Otherwise omit both the `## Link to ticket` and `## Testing` sections entirely — don't leave them in empty.
8. Copy the markdown to the clipboard so it's one ⌘V away from pasting into GitHub, using a **quoted** heredoc (`<<'EOF'`) so the shell doesn't expand `$`, backticks, or other special characters that might appear in commit messages or file paths:
   ```bash
   pbcopy <<'EOF'
   ## Changes
   - <bullet>
   - <bullet>

   ## Link to ticket
   <ID>

   ## Testing
   On `<environment>` with `<user P-number>`.
   EOF
   ```
9. Output the identical markdown in the chat, wrapped in a fenced code block language-tagged `markdown`, with a short lead-in noting it's already on the clipboard — nothing else of substance outside the block. This keeps the markdown as literal, unrendered source — sending it as normal chat prose would let Claude Code's own rendering swallow the `##`/`-` syntax before the user can copy it.

## Common Mistakes
- Rendering the summary as normal chat markdown instead of fencing it in a fenced `markdown` block — the user loses the literal `##`/`-` syntax and can't paste it as-is.
- Copy-pasting the raw PR title as the section header instead of the fixed `## Changes` label.
- Auto-detecting a ticket ID from the title's shape and skipping the P+ question — always ask; a parenthetical alone isn't confirmation this is a P+ project.
- Constructing a guessed Atlassian/Jira URL for the ticket ID instead of pasting the bare ID — let GitHub's autolink reference (the same one that links it in the PR title) do the linking.
- Including empty `## Link to ticket` / `## Testing` sections when the answer was no, or when yes but the ticket ID, environment, or user ID couldn't be found or supplied — omit the sections entirely instead.
- Guessing the test environment or fabricating a user ID instead of asking — both are user-provided every time (family via `AskUserQuestion`, then the number and the user ID both typed by the user), never inferred from the diff or PR title.
- Trying to put more than the two family options (`accept`, `pplus`) into the environment `AskUserQuestion` call — it hard-rejects anything over 4 options (input validation error, confirmed — not a soft display limit), and 12 (or even `pplus`'s 9) never fit.
- Adding a second `AskUserQuestion` tab to pick the specific number — after family, get the number as a plain typed answer, not another clickable pick.
- Forgetting to state the valid number range for the chosen family (`accept` 1-3, `pplus` 1-9) when asking for the number.
- Using `AskUserQuestion` for the test user ID — it needs ≥2 real clickable options and isn't a text box; ask that one as a plain chat question instead.
- Reusing the ticket ID from `## Link to ticket` as the user ID in `## Testing` — they're different values; ask for the user ID separately.
- Using an unquoted heredoc (`<<EOF` instead of `<<'EOF'`) with `pbcopy` — lets the shell expand `$`/backticks inside commit messages or filenames before they hit the clipboard.
- Letting the clipboard content and the chat-displayed content drift apart — copy and display the exact same markdown.
- Assuming the default branch is `main` — detect it (`gh repo view` or `git symbolic-ref refs/remotes/origin/HEAD`), since it may be `master` or something else.
- Pulling the full `git diff`/`gh pr diff` patch text for a large PR — use `--stat` plus targeted per-file diffs instead of flooding context with the whole patch.
- Listing every commit or every changed file — synthesize by theme instead; a PR with a dozen commits should still read as one coherent summary.
- Producing a summary when the diff is empty — say there's nothing to summarise instead of inventing content.
- Treating a failed `gh pr view` as an error to surface — it just means no PR is open yet; fall back to the branch diff silently.
