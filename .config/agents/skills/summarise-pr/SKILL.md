---
name: summarise-pr
description: Use when the user asks to summarise or summarize a PR (the current one, or a given PR number/URL), the current branch's changes, or "this diff" — phrases like "summarise this PR", "summarize PR 123", "summarise the diff", "summarize my changes", or "/summarise-pr". Produces paste-ready markdown (a short "What & why" abstract of the intent, all the changes, then testing instructions), copies it to the clipboard, and writes it to the top of the PR body when the PR is the user's own and open. Also draws an SVG diagram of the change, saved to the Desktop for the user to drag into the PR.
---

# Summarise PR

## Overview
Produces a summary of all the changes in a PR (the one the user names, else the current branch's PR, else the current branch's diff): a short `## What & why` abstract of the intent, then `## Changes` covering everything, then `## Testing Instructions` for checking it. That block is copied to the clipboard, shown as raw markdown source in a fenced code block, and, when there's an open PR of the user's own, written to the top of the PR body. Whatever the PR body already held (the PR template, filled in or not) stays below the block, so nobody has to open each PR and paste by hand.

It also draws an SVG diagram of the change (the flow it introduces, or a map of what changed), saves it to the Desktop, and reveals it in Finder. The diagram is never posted automatically — GitHub has no API for attaching an image to a PR body, and hosting one would mean committing it or publishing a gist — so the user drags it in themselves.

## When to Use
Triggers: "summarise this PR", "summarize the PR", "summarize PR 123", "summarise <PR URL>", "summarise the diff", "summarize my changes", or `/summarise-pr` (optionally with a PR number or URL as the argument, and `--no-post` to only copy, not edit the PR).

## Steps
1. Confirm you're in a git repo: `git rev-parse --is-inside-work-tree` — if this fails and no PR URL was given, tell the user there's no git repository here and stop. (A full PR URL works from anywhere via `gh`.)
2. Determine the source of changes, in this order:
   - **A PR the user named** (number, `#123`, or URL): pass it to every `gh` call as `<pr>`:
     ```bash
     gh pr view <pr> --json number,title,url,body,headRefName,state,author
     gh pr diff <pr> --stat
     gh pr diff <pr>
     ```
     If `gh pr view <pr>` fails, tell the user that PR couldn't be found and stop — don't silently fall back to the current branch, that would summarise the wrong thing.
   - **Open PR for the current branch** (no PR named): if `gh` is installed (`command -v gh`), check for a PR:
     ```bash
     gh pr view --json number,title,url,body,headRefName,state,author 2>/dev/null
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
4. Read every change. The summary must account for all of the PR's changes, so every changed file needs to be understood, not just the headline ones. If the diff is large (rule of thumb: `--stat` lists more than ~15 files, or the full patch is too big to read comfortably), don't dump the whole patch into context at once — redirect it to a file in the scratchpad (e.g. `gh pr diff <pr> > <scratchpad-dir>/pr.diff`, or the `git diff` equivalent), find each file's starting line with `grep -n '^diff --git' <scratchpad-dir>/pr.diff`, and `Read` it in chunks via `offset`/`limit`, working through the `--stat` list in batches. Skip only files whose change is obvious from the name and stat alone (lockfiles, generated files, snapshots).
5. Synthesize, don't transcribe. If the branch/PR has multiple unrelated commits, group the summary by theme or area (e.g. "Auth", "CI", "Docs") instead of listing commit-by-commit or file-by-file. Use commit messages and the PR title/body (if any) as signal for *why*, not just *what*.
6. Write the summary as markdown, in three sections:
   - `## What & why` — a fixed, literal header, and the first section — a short abstract of the intent, like the standfirst of an article or a newspaper tagline: **2-3 sentences in one paragraph** saying what the problem was, why it mattered, and what this PR does about it in a nutshell. Plain prose in the reader's terms, with inline code for the few identifiers that matter; no bullets, no file lists, and don't restate the `## Changes` bullets — those are the detail, this is the point. Derive the intent from the PR title/body, commit messages, and any linked issue, not from the diff alone; if the motive isn't stated anywhere and can't be read from the code, say what is evident rather than inventing a business reason, and stay at two sentences instead of padding. The register to aim for (a style example, not content to reuse): "The global banner is read from a block list on the Portal root, so scheduling it in Umbraco would unpublish the whole portal. This reads each banner from its own `globalBannerPage` node instead, so the normal publish/unpublish scheduling works per banner, and `/content/site-root` keeps its URL and response shape so deployed portals and the app keep working."
   - `## Changes` — a fixed, literal section header (never the raw PR title text) — followed by bullets that together cover **all** the changes in the PR: every behaviour change, new/removed file, config/CI/dependency change, and refactor. There's no bullet cap; a big PR gets as many bullets as it needs. Nothing gets silently dropped — collapse genuine noise (formatting-only files, lockfile bumps, regenerated snapshots) into a single catch-all bullet (e.g. `- Housekeeping: lockfile bump, Prettier reformat of 4 files.`) rather than omitting it.
   - Group bullets under short `###` sub-headers when the change spans distinct areas (anything beyond ~8 bullets almost always does); prefer a flat bullet list for small PRs.
   - `## Testing Instructions` — a fixed, literal header, after `## Changes` — a numbered list a reviewer can follow to check the change works, **3-7 steps**: setup first only if this change needs something specific (an env var, a migration, seed data), then the action, each step ending with what they should see (`→ expected result`), and finally the one or two things that used to work and are most likely to break because of this change. Name the real commands, routes, and screens from the diff, and take the commands for automated tests from the repo (`package.json` scripts, `CLAUDE.md`/`AGENTS.md`, README) rather than guessing — if the PR adds or changes tests, say which command runs them. **Leave out the self-evident**: checking out the branch, installing dependencies, starting the dev server and opening it on localhost, and running lint, typecheck, or build — every reviewer does the first ones anyway and CI covers the last. The first step should be the first thing specific to this change (the page or endpoint to open, the setting to flip). These are instructions, not a result: never write or imply that the steps were run. When there's nothing to exercise by hand (docs, CI config, a lockfile bump), say so in one line and what to look at instead, e.g. "No manual testing needed — CI-only change; the PR's checks are the test."
   - **Never hard-wrap.** Each bullet and each paragraph is one continuous line, however long — no newline in the middle of a sentence to keep lines under ~80-100 chars. GitHub, Slack, and Notion don't reflow embedded newlines the way the chat UI does, so a mid-bullet `\n` shows up as a literal line break and the user has to delete each one by hand. The only newlines allowed are between blocks: after a heading, between bullets, and blank lines between sections. Nested sub-bullets are fine; wrapped continuation lines are not.
7. Copy the markdown to the clipboard so it's one ⌘V away from pasting into GitHub. Write it to a scratchpad file with a **quoted** heredoc (`<<'EOF'`) so the shell doesn't expand `$`, backticks, or other special characters that might appear in commit messages or file paths, then `pbcopy` from that same file so the clipboard and the PR can never drift:
   ```bash
   cat > <scratchpad-dir>/summary-block.md <<'EOF'
   ## What & why

   <2-3 sentences, one unwrapped line>

   ## Changes
   - <bullet, one unwrapped line>
   - <bullet, one unwrapped line>

   ## Testing Instructions
   1. <step → expected result, one unwrapped line>
   2. <step → expected result, one unwrapped line>
   EOF
   pbcopy < <scratchpad-dir>/summary-block.md
   ```
8. **Post to the PR body** — only when all of these hold; otherwise skip this step and say why in one line (never ask, never post "close enough"):
   - a PR exists (named, or the current branch's) — the branch-diff-only paths have nothing to post to; the clipboard block is what the user pastes when they open the PR;
   - `state` is `OPEN`;
   - its `author.login` equals `gh api user -q .login` — never rewrite a teammate's PR body, even when the user asked to *summarise* it;
   - the user didn't pass `--no-post`.

   The block goes between a start and an end marker, which makes re-runs replace it in place: if the old body already has the markers, only what's between them changes, so anything the user added around them — like the diagram they dragged in above — stays where it is. With no markers yet, the marked block goes at the very top and the whole old body follows below it. If the old body is empty and the checkout has a PR template (`.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `docs/pull_request_template.md`, or `pull_request_template.md` at the root), the template goes below the block so it's still there to fill in. Save the old body first so it can be restored:
   ```bash
   gh pr view <pr> --json body -q .body > <scratchpad-dir>/pr-<number>-body-before.md
   python3 -I - <scratchpad-dir>/pr-<number>-body-before.md <scratchpad-dir>/summary-block.md "<template path or empty string>" <scratchpad-dir>/pr-<number>-body-after.md <<'PY'
   import re, sys
   old, block, template, out = sys.argv[1:5]
   body = open(old).read()
   mid = '<!-- summarise-pr:start -->\n' + open(block).read().strip() + '\n\n<!-- summarise-pr:end -->'
   pattern = re.compile(r'<!-- summarise-pr:start -->.*?<!-- summarise-pr:end -->', re.S)
   if pattern.search(body):
       new = pattern.sub(lambda m: mid, body, count=1)
   else:
       rest = body.strip() or (open(template).read().strip() if template else '')
       new = mid + ('\n\n' + rest if rest else '')
   open(out, 'w').write(new.rstrip() + '\n')
   PY
   gh pr edit <pr> --body-file <scratchpad-dir>/pr-<number>-body-after.md
   ```
   If `gh pr edit` errors (older `gh` versions choke on a Projects GraphQL query), do the same edit through the API: `gh api -X PATCH repos/<owner>/<repo>/pulls/<number> -F body=@<scratchpad-dir>/pr-<number>-body-after.md` (owner/repo from the PR URL).

   Then re-fetch (`gh pr view <pr> --json body -q .body`) and confirm it contains the block between the markers and that the rest of the old body is still there. If the edit failed or the check doesn't hold, say so plainly and point at the saved before-file — don't claim it was posted.
9. Create the SVG diagram:
   - **Pick the form that fits the PR.** If the PR introduces or changes a *flow* — a request/data path, user journey, state machine, pipeline, auth handshake, event sequence — draw that flow (boxes and arrows, left-to-right or top-to-bottom, with the new/changed steps highlighted). Otherwise draw a *change map*: one card per area/module from the `## Changes` grouping, each listing its key changes in a few words. One diagram, not both; pick whichever explains the PR faster to a reviewer.
   - **Keep it a glanceable companion to the markdown**, not a second copy of it: short labels (a few words each), roughly 4-12 nodes/cards, the PR title (or branch name) as a heading at the top. If it needs a paragraph to explain, it's too detailed.
   - **Colour it, and add a legend** when colours are used: neutral grey for untouched context, light fills with a darker outline of the same hue for the rest — new `#dafbe1` / `#1a7f37`, changed `#fff8c5` / `#9a6700`, no longer used `#ffebe9` / `#cf222e` (GitHub's diff hues). The legend runs along the bottom as a row of small rounded squares (about 20px, same fill and outline) with the word beside each — "new", "changed", "no longer used" — listing only the colours the diagram uses.
   - **Write it for GitHub's image renderer.** GitHub serves uploaded SVGs through an `<img>` tag with scripts stripped, so the file must be fully self-contained:
     - Root: `<svg xmlns="http://www.w3.org/2000/svg" width="W" height="H" viewBox="0 0 W H">` with explicit `width`/`height` (W around 900-1200 so it stays legible when GitHub scales it to the ~880px content column).
     - A full-size opaque background `<rect>` (e.g. `#ffffff`, rounded corners fine) as the first child — without it, dark text vanishes against GitHub's dark theme.
     - Fonts: `font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif"`, body text ≥ 14px, headings ~20px. No web fonts, `@import`, external `href`s, `<script>`, or `<foreignObject>` (none of these survive `<img>` rendering).
     - Text: plain `<text>`/`<tspan>` only, so size every box to fit its longest label — SVG doesn't wrap text, so break long labels across `<tspan>`s manually. Escape `&`, `<`, `>` in labels as `&amp;`, `&lt;`, `&gt;`.
     - Arrows: define one `<marker>` arrowhead in `<defs>` and reuse it via `marker-end`.
   - **Save it where Finder can reach it**: `~/Desktop/pr-<number>-summary.svg` (or `~/Desktop/<branch-name-with-slashes-replaced-by-dashes>-summary.svg` when there's no PR). Overwrite an existing file of the same name — it's a regenerated artifact.
   - **Verify before handing it over**:
     ```bash
     xmllint --noout ~/Desktop/pr-<number>-summary.svg
     qlmanage -t -s 1600 -o <scratchpad-dir> ~/Desktop/pr-<number>-summary.svg >/dev/null 2>&1
     ```
     Then `Read` the resulting `<scratchpad-dir>/pr-<number>-summary.svg.png` and check it visually: no overlapping or clipped text, labels inside their boxes, arrows landing on the right nodes, legend swatches aligned with their words. (Quick Look pads the thumbnail to a square with white space — that's the preview, not the SVG.) Fix and re-render until clean.
   - **Reveal it in Finder** with the file pre-selected, ready to drag into the PR description or a comment: `open -R ~/Desktop/pr-<number>-summary.svg`.
10. Output the identical markdown in the chat, wrapped in a fenced code block language-tagged `markdown`, with a short lead-in noting it's already on the clipboard — nothing else of substance outside the block. This keeps the markdown as literal, unrendered source — sending it as normal chat prose would let Claude Code's own rendering swallow the `##`/`-` syntax before the user can copy it. After the block, one line on the PR: `Posted to <PR URL> — What & why, the changes, and the testing instructions are at the top of the body, the previous body is kept below it (before-file: <path>).` or `Not posted: <reason>.` Then one line giving the SVG's path (e.g. `Diagram: ~/Desktop/pr-123-summary.svg — revealed in Finder, drag it into the PR.`).

## Common Mistakes
- Rendering the summary as normal chat markdown instead of fencing it in a fenced `markdown` block — the user loses the literal `##`/`-` syntax and can't paste it as-is.
- Hard-wrapping bullets or paragraphs at ~80-100 chars — every bullet/paragraph must be one unbroken line, or each wrap becomes a stray line break in GitHub that the user has to delete by hand.
- Leaving changes out of `## Changes` — capping at a handful of headline bullets, or dropping config/CI/test/dependency changes as "not meaningful". Everything is covered; only genuine noise gets collapsed, into a catch-all bullet, never omitted.
- Summarising from the `--stat` file list alone on a large PR — that's enough to name files, not to describe what changed in them; read the per-file diffs in batches.
- Falling back to the current branch when the user named a PR that `gh` couldn't find — stop and say so instead.
- Copy-pasting the raw PR title as a section header instead of the fixed `## What & why` and `## Changes` labels.
- A `## What & why` that is a bullet list, a file list, or a paragraph-long essay — it's 2-3 sentences of prose: the problem, why it mattered, what was done. If it just restates `## Changes`, it has no reason to exist.
- Inventing a motive for the `## What & why` when nothing in the PR, commits, or code states one — write what is evident and keep it short.
- Putting `## What & why` after `## Changes` — it's the first section, and `## Testing Instructions` is the last.
- Vague testing instructions ("run the tests", "verify it works") or invented commands and routes — name the actual command from the repo and the actual screen from the diff, with the expected result for each step.
- Padding the testing instructions with boilerplate steps every reviewer already does — checking out the branch, installing dependencies, "start the dev server and go to localhost:3000", "run lint/build" (CI covers those). Start at the first step that's specific to this change.
- Phrasing the testing instructions as if they'd been run ("tested locally, all passing") — nothing was run; they're steps for the reviewer.
- Using an unquoted heredoc (`<<EOF` instead of `<<'EOF'`) — lets the shell expand `$`/backticks inside commit messages or filenames before they hit the clipboard or the PR.
- Letting the clipboard, the chat block, and the PR body drift apart — all three come from the one `summary-block.md`.
- Replacing the PR body instead of prepending to it — the PR template and anything the author wrote must survive.
- Posting a second block on a re-run instead of replacing the first between the markers, or moving what the user put around the markers (such as the dragged-in diagram) when replacing it.
- Editing a PR that isn't the user's own, or isn't open — summarising someone else's PR is read-only.
- Skipping the save of the old body before `gh pr edit` — there'd be no way back.
- Putting an image placeholder or `![...]()` link for the SVG into the markdown or the PR body — GitHub inserts its own image markdown when the file is dropped in; a placeholder would just be a broken link to delete.
- Trying to get the SVG into the PR body yourself — there's no API to attach an image, and every way to host it (commit, gist) publishes something the user didn't ask for. The user drags it in.
- Saving the SVG to the scratchpad or `/tmp` — the user can't find it in Finder there. It goes on the Desktop, and gets revealed with `open -R`.
- An SVG with a transparent background, web fonts, `<foreignObject>`, scripts, or external references — it either renders blank/unreadable in GitHub's dark theme or gets stripped by GitHub's `<img>` sandbox.
- Handing over the SVG without rendering it via `qlmanage` and looking at it — overlapping labels and text overflowing boxes are invisible in the source and obvious in the PNG.
- Colouring the diagram without a legend, or with legend entries for colours it doesn't use.
- Cramming the whole `## Changes` list into the diagram — it's a glanceable overview (4-12 short-labelled nodes), not a second copy of the text.
- Assuming the default branch is `main` — detect it (`gh repo view` or `git symbolic-ref refs/remotes/origin/HEAD`), since it may be `master` or something else.
- Pulling the full `git diff`/`gh pr diff` patch text for a large PR in one go — use `--stat` plus batched per-file diffs instead of flooding context with the whole patch.
- Listing every commit or every changed file one by one — cover all changes, but synthesize them by theme; a PR with a dozen commits should still read as one coherent summary.
- Producing a summary when the diff is empty — say there's nothing to summarise instead of inventing content.
- Treating a failed `gh pr view` (with no PR named) as an error to surface — it just means no PR is open yet; fall back to the branch diff silently.
