---
name: commit-split
description: Use when the user wants the uncommitted work on a PR or branch split into several meaningful commits — phrases like "split this into commits", "commit this properly", "break my changes into commits", "make commits out of this", or "/commit-split" (optionally with a PR number or URL). Plans the commits as conventional commits with names and descriptions, asks for approval, then commits locally. Never pushes.
---

# Commit Split

## Overview
Takes all the uncommitted work in the working tree of a PR's branch (staged, unstaged, and untracked), groups it into logical commits, and shows the plan: conventional commit names plus descriptions. Only after the user approves does it create the commits. It never pushes: the commits stay local until the user decides to push them. Commits already on the branch are never touched.

Arguments (optional): `/commit-split [<PR number or URL>]`. With none, it uses the current branch's PR if there is one, else just the current branch.

## When to Use
Triggers: "split this into commits", "commit this properly", "break my changes into commits", "make commits out of this", or `/commit-split`. Not for reorganising commits that already exist (that's a rebase) and not for a single obvious commit the user could have asked for directly.

## Steps
1. **Preflight.**
   - `git rev-parse --is-inside-work-tree` — no repo, tell the user and stop.
   - Stop if the tree has unmerged paths or a merge/rebase/cherry-pick in progress (`git status` says so) — committing mid-operation would corrupt it. Tell the user to finish or abort it first.
   - Find the default branch (`gh repo view --json defaultBranchRef -q .defaultBranchRef.name`, else `git symbolic-ref refs/remotes/origin/HEAD`, else check for `origin/main` / `origin/master` / `origin/develop` / `origin/devel`, etc. — don't assume `main`). If the current branch *is* the default branch, say so and ask whether to continue or first create a branch; commits on the default branch are easy to push by accident.
   - `git status --porcelain=v1 -uall`. Empty output means no uncommitted work: say so and stop.
2. **Resolve the PR.** Uncommitted work only exists in this checkout, so the PR must be the one this checkout is on.
   - **A PR the user named:** `gh pr view <pr> --json number,title,url,body,headRefName,baseRefName`. If it fails, say the PR couldn't be found and stop — don't quietly use the current branch. If `headRefName` isn't `git branch --show-current`, stop and tell the user which branch the PR is on (and, if `git worktree list` shows it checked out elsewhere, which worktree to run this from). Never switch branches yourself.
   - **No PR named:** try the same `gh pr view` without `<pr>` and silently carry on without PR metadata if it fails (no `gh`, or no PR opened yet).
   - Use the PR title/body and `git log --oneline origin/<base>..HEAD` as context for intent, scope names, and style. They tell you *why* the work exists, not just what changed.
3. **Snapshot the work.** Record the tree the commits must add up to, using a throwaway index so the real one isn't touched:
   ```bash
   rm -f <scratchpad-dir>/commit-split.index
   export GIT_INDEX_FILE=<scratchpad-dir>/commit-split.index
   git read-tree HEAD && git add -A && git write-tree
   unset GIT_INDEX_FILE
   ```
   Note the printed tree hash (call it T) and `git rev-parse HEAD` (the starting point). Both are used in step 9.
4. **Read every change.** All uncommitted work must be understood, not just the headline files.
   - Tracked changes, staged and unstaged together: `git diff HEAD --stat`, then `git diff HEAD`. For a large diff (rule of thumb: more than ~15 files), redirect the patch to `<scratchpad-dir>/work.diff`, find each file with `grep -n '^diff --git'`, and `Read` it in chunks via `offset`/`limit` instead of dumping it into context.
   - Untracked files (`??` in status) don't appear in `git diff`; `Read` each one. Skip binaries and generated blobs; judge them by name and size.
   - Skip reading only what's obvious from name and stat: lockfiles, snapshots, generated output.
5. **Learn the repo's commit conventions.** Check `CLAUDE.md` / `AGENTS.md` / `CONTRIBUTING.md`, a commitlint config (`commitlint.config.*`, `.commitlintrc*`, or a `commitlint` key in `package.json`), and `git log -20 --format=%s`. Use the scopes and ticket-footer habits found there. If the repo's own rules are stricter than conventional commits (allowed types/scopes, required footer), follow them. If recent history isn't conventional, still use conventional commits — the user asked for it.
6. **Draft the plan.**
   - **One commit = one logical change** that a reviewer can understand alone. Not one commit per file, and not one giant commit. If the work really is a single change, a one-commit plan is a valid answer.
   - **Assign everything.** Every changed and untracked file goes in exactly one commit. A file may be split across commits by hunk only when its hunks are clearly independent (e.g. an unrelated formatting change or a drive-by fix mixed into a feature file); say so in the plan. Files that look like they shouldn't be committed at all — `.env*`, keys, logs, build output, editor junk, leftover debug code — go under **Left out** for the user to decide, never silently included or dropped.
   - **Keep together:** a manifest with its lockfile; generated files with their source; tests with the code they cover (a separate `test:` commit only when the tests are a distinct chunk of work); a rename's delete and add.
   - **Separate:** refactors from behaviour changes; formatting-only churn from logic; unrelated fixes from the feature; dependency/build/CI changes from application code.
   - **Order** so each commit stands on its own where practical: types and helpers before their users, a refactor before the feature that relies on it. If two commits only work together, say so in the plan.
   - **Name** each commit `type(scope): subject`, conventional commits 1.0: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style` (formatting only), `revert`. Scope is optional: a short noun for the area, reusing scopes from step 5. Subject in imperative mood, lower-case start, no trailing period, aim for ≤ 60 characters, hard cap 72. Mark breaking changes with `!` and a `BREAKING CHANGE:` footer.
   - **Describe** each commit with a body of one to four lines: *why* the change exists first, then anything a reviewer wouldn't guess from the diff. Bullets are fine for distinct points. Trivial commits still get a one-sentence body. Add a `Refs:` / ticket footer only if the repo's recent commits do. **Don't hard-wrap the body:** each paragraph or bullet is one continuous line, because GitHub pre-fills PR descriptions from commit bodies and shows single newlines as literal line breaks.
7. **Get approval.** Show the plan in chat as normal markdown (it's read here, not pasted elsewhere), then ask.
   ```
   ### Plan: 3 commits on `feature/token-refresh` (PR #123)

   1. `feat(auth): refresh access tokens before they expire`
      Files: `src/auth/refresh.ts` (new), `src/auth/client.ts`
      Description: Access tokens were only refreshed after a 401, which dropped in-flight requests. Refresh proactively once 80% of the lifetime has passed.

   2. `test(auth): cover proactive token refresh`
      Files: `src/auth/refresh.test.ts` (new)
      Description: ...

   **Left out:** `.env.local` — looks like secrets, not committing it.
   ```
   Ask with `AskUserQuestion` when available (plain chat otherwise), saying in the question that commits are made locally and nothing is pushed:
   - **Approve — commit locally** (recommended)
   - **Adjust the plan** — ask in plain chat what to change (merge, split, reword, move a file), revise, show the full updated plan, and ask again.
   - **Cancel** — stop; nothing has been touched.
   Free-text answers that change the plan count as *Adjust*. Approval covers exactly the plan that was shown; any change needs a fresh approval. Don't create a single commit before an explicit approve.
8. **Commit.** Run `git reset -q` once first: it empties the index (the user's earlier staging is folded into the plan) and leaves the working tree exactly as it is. Then, per commit in plan order:
   - **Stage exactly the planned files:** `git add -A -- <paths>` (handles deletions and renames; include both paths of a rename).
   - **Stage a subset of a file's hunks** (non-interactive — `git add -p` needs a TTY): generate the diff fresh with `git diff -U0 -- <file> > <scratchpad-dir>/part.patch`, edit the patch (with `Write`/`Edit`) down to the file header plus the chosen `@@` hunks, then `git apply --cached --unidiff-zero --recount <scratchpad-dir>/part.patch`. Regenerate the diff after every commit, because line numbers shift.
   - **Check the staging before committing:** `git diff --cached --stat` must match the plan for this commit, nothing more, nothing less. If not, `git reset -q` and redo the staging.
   - **Commit** with a quoted heredoc so the shell doesn't expand `$`, backticks, or quotes in the message:
     ```bash
     git commit -F - <<'EOF'
     feat(auth): refresh access tokens before they expire

     Access tokens were only refreshed after a 401, which dropped in-flight requests. Refresh proactively once 80% of the lifetime has passed.
     EOF
     ```
     Append any commit attribution trailer your environment or the user requires (e.g. `Co-Authored-By:`) after a blank line.
   - **Hooks:** never `--no-verify`. If a hook rejects the commit, nothing was created: show the output, fix it if the fix is unambiguous and in scope, then retry the same commit; otherwise stop and ask. If a hook rewrites files (formatters), the final tree in step 9 will legitimately differ from T; say so instead of hiding it.
   - A commit that came out wrong is not amended or reset behind the user's back: stop, show what happened, and ask.
9. **Verify and report.**
   - `git status --porcelain` shows only the **Left out** paths (empty if there were none).
   - If nothing was left out, `git rev-parse HEAD^{tree}` equals T. That proves the commits add up to exactly the uncommitted work, no more and no less. If they differ, show `git diff --stat T HEAD` and explain; don't paper over it.
   - `git log --oneline <starting-HEAD>..HEAD` to list what was made, and `git status -sb` to confirm the branch is only ahead locally.
   - Report in a few lines: the commits (short hash + subject), anything left uncommitted and why, and that the commits are local and unpushed. Don't offer to push.

## Never
`git push` (any form, including `--force`, or `gh` commands that change the PR), `git commit --amend`, `git rebase`, `git reset --hard`, `git checkout -- <file>` / `git restore` on working files, `git stash` (the stash would hide the very work being committed), `--no-verify`, or switching branches. The only history change is adding the approved commits on top of the current HEAD.

## Common Mistakes
- Committing before the user has explicitly approved the plan, or after they asked for changes to it, on the strength of the earlier approval.
- Pushing, "just to see the PR update".
- Building the plan from `git diff --stat` alone — file names don't reveal which hunks belong to which change. Read the diff.
- Forgetting untracked files: `git diff` doesn't list them, so a plan built from it silently strands new files.
- Ignoring the index: assuming staged files are already "done" instead of treating staged and unstaged work as one pool.
- One commit per file, or one commit for everything, when the work has several distinct concerns (or one, when it doesn't).
- Mixing a formatter run or drive-by rename into a feature commit, which makes the feature diff unreviewable.
- Splitting a manifest from its lockfile, or a source file from its generated output.
- Silently committing `.env`, keys, logs, or build artifacts, or silently leaving files out — anything not committed appears under **Left out** in the plan.
- Vague names like `chore: update files` or `fix: stuff`; the subject says what changed, the body says why.
- Hard-wrapping commit bodies at 72 columns — each paragraph or bullet is one line (see step 6).
- Using `git add -p` or `git add -i` — they need a TTY. Use `git apply --cached` with a hand-trimmed patch.
- Reusing a stale hunk patch after an earlier commit changed the same file — regenerate it.
- Using an unquoted heredoc for the message, letting the shell expand `$`/backticks in it.
- Skipping the final tree check: it's the only proof no work was dropped or duplicated.
- Switching to the PR's branch yourself when the checkout is on a different one — stop and tell the user.
