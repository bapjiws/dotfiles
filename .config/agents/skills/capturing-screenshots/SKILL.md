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
2. For each label, in the order mentioned:
   - Run, via Bash:
     ```bash
     rm -f ~/Desktop/img<label>.png; screencapture -i ~/Desktop/img<label>.png; [ -f ~/Desktop/img<label>.png ] && echo CAPTURED || echo CANCELLED
     ```
     This blocks while the user drags to select a region (Esc cancels).
   - If output is `CANCELLED`, tell the user this one was cancelled and continue to the next label.
   - If `CAPTURED`, use the Read tool on `~/Desktop/img<label>.png` to view it.
3. After every mentioned label has been captured (or skipped as cancelled), respond using what's shown in each.

## Common Mistakes
- Forgetting `rm -f` first — a stale screenshot gets read as new if this capture is cancelled.
- Skipping the Read step — capturing without viewing defeats the purpose.
- Stopping after the first label when the message mentions several (e.g. "see img1 and img2") — repeat step 2 for every label, don't stop at one.
- Deferring a label because it's phrased as future/narrative intent (e.g. "I'll also ask about img3") instead of a direct command — every mention is a request for now, in the same turn as the rest of the message.
- Silent failure (no crosshair appears, 0-byte file): the terminal app running Claude Code needs Screen Recording permission (System Settings → Privacy & Security → Screen Recording).
