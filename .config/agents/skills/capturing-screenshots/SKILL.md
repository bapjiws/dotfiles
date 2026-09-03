---
name: capturing-screenshots
description: Use when the user asks to see, take, or capture a screenshot mid-conversation — phrases like "see img1", "see img2", "see img<N>", or "take a screenshot" — on macOS.
---

# Capturing Screenshots

## Overview
Captures a fresh interactive screenshot to a predictable path and views it immediately — no manual `@file` reference needed.

## When to Use
Triggers: "see img1", "see img2", "see img<label>" (any label), or a bare "see screenshot" / "take a screenshot". Default label is `1` when none is given.

## Steps
1. Extract every `img<label>` mentioned anywhere in the message as something to capture — not just direct "see imgN" phrasing, but also narrative or future-sounding mentions like "I'll also ask about img3" or "then grab img3". Any such mention means capture it now, in this same turn — never defer one to a follow-up message just because of how it's phrased.
2. For each label, in the order mentioned, run **one** Bash call per label — don't split into separate calls, each extra round-trip is visible delay:
   ```bash
   rm -f ~/Desktop/img<label>.png; screencapture -i ~/Desktop/img<label>.png; [ -f ~/Desktop/img<label>.png ] && echo CAPTURED || echo CANCELLED
   ```
   - On the **first** label only, prepend `open -a "Brave Browser"; ` to that same command (mirrors the alt+b Hammerspoon binding) — don't issue it as a separate call beforehand.
   - On the **last** label only, append `; open -a "Ghostty"` to that same command (mirrors alt+t), right after the CAPTURED/CANCELLED check — this snaps focus back the instant the capture finishes, not after the Read/response processing that follows.
   - (A single-label message is both first and last: one Bash call carries the browser-open prefix, the capture, and the terminal-open suffix together.)
   - Each capture blocks while the user drags to select a region (Esc cancels).
   - If output is `CANCELLED`, tell the user this one was cancelled and continue to the next label.
   - If `CAPTURED`, use the Read tool on `~/Desktop/img<label>.png` to view it.
3. Respond using what's shown in each captured image.

## Common Mistakes
- Forgetting `rm -f` first — a stale screenshot gets read as new if this capture is cancelled.
- Skipping the Read step — capturing without viewing defeats the purpose.
- Stopping after the first label when the message mentions several (e.g. "see img1 and img2") — repeat step 2 for every label, don't stop at one.
- Deferring a label because it's phrased as future/narrative intent (e.g. "I'll also ask about img3") instead of a direct command — every mention is a request for now, in the same turn as the rest of the message.
- Issuing `open -a` as its own separate Bash call instead of chaining it into the capture command — each extra tool round-trip adds visible delay; fold it into the same call as described in step 2.
- Silent failure (no crosshair appears, 0-byte file): the terminal app running Claude Code needs Screen Recording permission (System Settings → Privacy & Security → Screen Recording).
