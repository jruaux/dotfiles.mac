-------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------
hs.window.animationDuration = 0

units = {
  right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right60       = { x = 0.40, y = 0.00, w = 0.60, h = 1.00 },
  right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },  
  left55        = { x = 0.00, y = 0.00, w = 0.55, h = 1.00 },
  left40        = { x = 0.00, y = 0.00, w = 0.40, h = 1.00 },
  left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },  
  top70         = { x = 0.00, y = 0.00, w = 1.00, h = 0.70 },
  bot30         = { x = 0.00, y = 0.70, w = 1.00, h = 0.30 },
  upright30     = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
  botright60    = { x = 0.30, y = 0.40, w = 0.70, h = 0.60 },
  upleft50      = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  botleft70     = { x = 0.00, y = 0.50, w = 0.70, h = 0.50 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

layouts = {
  -- I'll use 'work' as my example. If I want to position the windows of
  -- all of these applications, then I simply specify 'layouts.work' and 
  -- then the layout engine will move all of the windows for these apps to
  -- the right monitor and in the right position on that monitor.
  work = {
    -- { name = 'VimR',              unit = units.left70,  screen = 'DELL P2715Q' },
    { name = 'Safari',            app = 'Safari.app',             unit = units.maximum,    screen = 'DELL P2715Q' },
    { name = 'Terminal',          app = 'Terminal.app',           unit = units.bot30,      screen = 'DELL P2715Q' },
    { name = 'Messages',          app = 'Messages.app',           unit = units.left40,     screen = 'Color LCD' },
    { name = 'Reminders',         app = 'Reminders.app',          unit = units.upleft50,   screen = 'Color LCD' },
    { name = 'Calendar',          app = 'Calendar.app',           unit = units.botright60, screen = 'Color LCD' },
    { name = 'Mail',              app = 'Mail.app',               unit = units.maximum,    screen = 'Color LCD' },
    { name = 'Notes',             app = 'Notes.app',              unit = units.left55,     screen = 'Color LCD' },
    { name = 'Slack',             app = 'Slack.app',              unit = units.right60,    screen = 'Color LCD' }
  }
}

-- Takes a layout definition (e.g. 'layouts.work') and iterates through
-- each application definition, laying it out as speccified
function runLayout(layout)
  for i = 1,#layout do
    local t = layout[i]
    local theapp = hs.application.get(t.name)
    if win == nil then
      hs.application.open(t.app)
      theapp = hs.application.get(t.name)
    end
    local win = theapp:mainWindow()
    local screen = nil
    if t.screen ~= nil then
      screen = hs.screen.find(t.screen)
    end
    win:move(t.unit, screen, true)
  end
end

function moveToNextScreen() 
  -- Get the focused window, its window frame dimensions, its screen frame dimensions,
  -- and the next screen's frame dimensions.
  local focusedWindow = hs.window.focusedWindow()
  local focusedScreenFrame = focusedWindow:screen():frame()
  local nextScreenFrame = focusedWindow:screen():next():frame()
  local windowFrame = focusedWindow:frame()

  -- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
  windowFrame.x = ((((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
  windowFrame.y = ((((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
  windowFrame.h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
  windowFrame.w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

  -- Set the focused window's new frame dimensions
  focusedWindow:setFrame(windowFrame)
end

mash = {'ctrl', 'alt', 'cmd' }
hs.hotkey.bind(mash, 'right', function() hs.window.focusedWindow():move(units.right60,    nil, true) end)
hs.hotkey.bind(mash, 'left', function() hs.window.focusedWindow():move(units.left40,     nil, true) end)
hs.hotkey.bind(mash, 'up', function() hs.window.focusedWindow():move(units.top70,      nil, true) end)
hs.hotkey.bind(mash, 'down', function() hs.window.focusedWindow():move(units.bot30,      nil, true) end)
hs.hotkey.bind(mash, '2', function() hs.window.focusedWindow():move(units.upright30,  nil, true) end)
hs.hotkey.bind(mash, '1', function() hs.window.focusedWindow():move(units.upleft50,   nil, true) end)
hs.hotkey.bind(mash, '3', function() hs.window.focusedWindow():move(units.botleft70,  nil, true) end)
hs.hotkey.bind(mash, "4", function() hs.window.focusedWindow():move(units.botright30, nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)
hs.hotkey.bind(mash, 'n', moveToNextScreen)
hs.hotkey.bind(mash, '0', function() runLayout(layouts.work) end)