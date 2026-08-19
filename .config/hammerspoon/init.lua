hs.window.animationDuration = 0

local appLaunchers = {
  b = "Brave Browser",
  t = "Ghostty",
  m = "Slack",
  n = "Obsidian",
  c = "Claude",
  d = "Figma",
  o = "Orca",
  e = "Microsoft Outlook",
}

for key, appName in pairs(appLaunchers) do
  hs.hotkey.bind({"alt"}, key, function()
    hs.application.launchOrFocus(appName)
  end)
end

-- New Finder window (mirrors: alt - f)
hs.hotkey.bind({"alt"}, "f", function()
  hs.osascript.applescript([[
    tell application "Finder"
      make new Finder window
      activate
    end tell
  ]])
end)

-- ===== Window move/resize (mirrors: cmd+alt - left/right/up/f) =====

local function setWindowGrid(win, x, y, w, h)
  if not win then return end
  local f = win:screen():frame()
  win:setFrame({
    x = f.x + f.w * x,
    y = f.y + f.h * y,
    w = f.w * w,
    h = f.h * h,
  })
end

-- snap window to left half
hs.hotkey.bind({"cmd", "alt"}, "left", function()
  setWindowGrid(hs.window.focusedWindow(), 0, 0, 0.5, 1)
end)

-- snap window to right half
hs.hotkey.bind({"cmd", "alt"}, "right", function()
  setWindowGrid(hs.window.focusedWindow(), 0.5, 0, 0.5, 1)
end)

-- make window fill screen
hs.hotkey.bind({"cmd", "alt"}, "up", function()
  setWindowGrid(hs.window.focusedWindow(), 0, 0, 1, 1)
end)

-- toggle native fullscreen
hs.hotkey.bind({"cmd", "alt"}, "f", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:setFullScreen(not win:isFullScreen())
end)

-- ===== Multi-monitor (mirrors: shift+alt - 1/2/3, shift+cmd - 1/2/3) =====

-- Screens sorted left-to-right so "1/2/3" map onto physical arrangement,
-- similar to how yabai numbers displays. This ordering may not exactly
-- match yabai's internal display indices -- adjust getSortedScreens()
-- if your numbering feels off (e.g. sort by y for a vertical layout).
local function getSortedScreens()
  local screens = hs.screen.allScreens()
  table.sort(screens, function(a, b)
    local fa, fb = a:frame(), b:frame()
    if fa.x ~= fb.x then return fa.x < fb.x end
    return fa.y < fb.y
  end)
  return screens
end

-- move the mouse cursor to the center of a window, so focus changes are
-- visually obvious across displays
local function moveMouseToWindow(win)
  local f = win:frame()
  hs.mouse.absolutePosition({x = f.x + f.w / 2, y = f.y + f.h / 2})
end

-- focus monitor: focus its frontmost standard window and bring the mouse
-- along, or just move the mouse there if it has no windows
local function focusDisplay(n)
  local screen = getSortedScreens()[n]
  if not screen then return end

  for _, win in ipairs(hs.window.orderedWindows()) do
    if win:isStandard() and win:screen() == screen then
      win:focus()
      moveMouseToWindow(win)
      return
    end
  end

  local f = screen:frame()
  hs.mouse.absolutePosition({x = f.x + f.w / 2, y = f.y + f.h / 2})
end

-- send focused window to monitor and follow focus
-- (moveToScreen keeps the window focused, so no extra focus call needed)
local function sendWindowToDisplay(n)
  local win = hs.window.focusedWindow()
  local screen = getSortedScreens()[n]
  if not win or not screen then return end
  win:moveToScreen(screen)
  moveMouseToWindow(win)
end

for i = 1, 3 do
  hs.hotkey.bind({"shift", "alt"}, tostring(i), function() focusDisplay(i) end)
  hs.hotkey.bind({"shift", "cmd"}, tostring(i), function() sendWindowToDisplay(i) end)
end

-- ===== Extra: move cursor to the focused window (not in yabai/skhd) =====

hs.hotkey.bind({"cmd", "alt"}, "m", function()
  local win = hs.window.focusedWindow()
  if win then moveMouseToWindow(win) end
end)

-- also bring the cursor along on any focus change (app switch via cmd-tab,
-- dock click, our own app launchers above, etc.), not just this hotkey
local focusWatcher = hs.window.filter.new()
focusWatcher:subscribe(hs.window.filter.windowFocused, function(win)
  moveMouseToWindow(win)
end)

-- ===== Config reload (standard Hammerspoon convenience) =====

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", hs.reload)
hs.alert.show("Hammerspoon config loaded")
