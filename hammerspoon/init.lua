local grid = require "hs.grid"

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--       hs.notify.new({title="Hammerspoon", informativeText="Hello Notification World!"}):send()
-- end)

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
--       local win = hs.window.frontmostWindow() -- focusedWindow()
--       local f = win:frame()

--       f.x = f.x - 10
--       win:setFrame(f)
-- end)


----------------------------------------------------------------------
-- Ports of stuff from slinkp's ~/.slate
----------------------------------------------------------------------


-- Resize Bindings

MIN_SIZE = 20

function resizeCurrentWindowByPercent(widthPercent, heightPercent)
      local win = hs.window.frontmostWindow()
      local f = win:frame()
      local screen = win:screen()
      local sframe = screen:frame()
      if widthPercent > 0.0 then
         f.w = math.min(sframe.w, f.w + (widthPercent * sframe.w))
      elseif widthPercent < 0.0 then
         f.w = math.max(MIN_SIZE, f.w + (widthPercent * sframe.w))
      end
      if heightPercent > 0.0 then
         f.h = math.min(sframe.h, f.h + (heightPercent * sframe.h))
      elseif heightPercent < 0.0 then
         f.h = math.max(MIN_SIZE, f.h + (heightPercent * sframe.h))
      end
      win:setFrame(f)
end


-- bind right:alt       resize +5% +0
hs.hotkey.bind({"alt"}, "right", function()
      -- resizeCurrentWindowByPercent(0.05, 0)
      local win = hs.window.frontmostWindow()
      hs.grid.resizeWindowWider(win)
end)

-- bind left:alt        resize -5% +0
hs.hotkey.bind({"alt"}, "left", function()
      -- resizeCurrentWindowByPercent(-0.05, 0)
      local win = hs.window.frontmostWindow()
      hs.grid.resizeWindowThinner(win)
end)


-- bind up:alt          resize +0   -5%
hs.hotkey.bind({"alt"}, "up", function()
      -- resizeCurrentWindowByPercent(0, -0.05)
      local win = hs.window.frontmostWindow()
      hs.grid.resizeWindowShorter(win)
end)

-- bind down:alt        resize +0   +5%
hs.hotkey.bind({"alt"}, "down", function()
      -- resizeCurrentWindowByPercent(0, 0.05)
      local win = hs.window.frontmostWindow()
      hs.grid.resizeWindowTaller(win)
end)

-- -- Could do these but I never used them much in practice
-- bind right:ctrl;alt  resize -5% +0 bottom-right
-- bind left:ctrl;alt   resize +5% +0 bottom-right
-- bind up:ctrl;alt     resize +0   +5% bottom-right
-- bind down:ctrl;alt   resize +0   -5% bottom-right


----------------------------------------------------------------------
-- Ports of stuff from slinkp's ~/.slate.js
----------------------------------------------------------------------
nudgeX = 30
nudgeY = 24
-- TODO how to move by that amount

----------------------------------------------------------------------
-- emacs-everywhere per 
----------------------------------------------------------------------

hyper = {"cmd","ctrl"}
hs.hotkey.bindSpec({hyper, "e"},
  function ()
    hs.task.new("/bin/bash", nil, { "-l", "-c", "emacsclient --eval '(emacs-everywhere)'" }):start()
  end
)


------------------------------------------------------------
-- Vertical maximize
------------------------------------------------------------

hs.hotkey.bind({"cmd", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)


--------------------------------------------
-- Grid movement?
----------------------------------------------

hs.grid.setGrid("8x5")

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "Up", function()
  local win = hs.window.focusedWindow()
  hs.grid.pushWindowUp(win)
end)

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "Down", function()
  local win = hs.window.focusedWindow()
  hs.grid.pushWindowDown(win)
end)

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "Right", function()
  local win = hs.window.focusedWindow()
  hs.grid.pushWindowRight(win)
end)

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "Left", function()
  local win = hs.window.focusedWindow()
  hs.grid.pushWindowLeft(win)
end)
