hs.window.animationDuration = 0

units = {
  right         = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left          = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  top           = { x = 0.00, y = 0.00, w = 1.00, h = 0.70 },
  bottom        = { x = 0.00, y = 0.70, w = 1.00, h = 0.30 },
  topleft       = { x = 0.00, y = 0.00, w = 0.50, h = 0.70 },
  topright      = { x = 0.50, y = 0.00, w = 0.50, h = 0.70 },
  bottomleft    = { x = 0.00, y = 0.70, w = 0.50, h = 0.30 },
  bottomright   = { x = 0.50, y = 0.70, w = 0.50, h = 0.30 },
  bottomright70 = { x = 0.30, y = 0.30, w = 0.70, h = 0.70 },  
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

layouts = {
  work = {
    { name = 'Safari',            app = 'Safari.app',             unit = units.maximum,       screen = 'DELL P2715Q' },
    { name = 'Terminal',          app = 'Terminal.app',           unit = units.bottom,        screen = 'DELL P2715Q' },
    { name = 'Messages',          app = 'Messages.app',           unit = units.left,          screen = 'Color LCD'   },
    { name = 'Reminders',         app = 'Reminders.app',          unit = units.topleft,       screen = 'Color LCD'   },
    { name = 'Calendar',          app = 'Calendar.app',           unit = units.bottomright70, screen = 'Color LCD'   },
    { name = 'Mail',              app = 'Mail.app',               unit = units.maximum,       screen = 'Color LCD'   },
    { name = 'Notes',             app = 'Notes.app',              unit = units.left,          screen = 'Color LCD'   },
    { name = 'Slack',             app = 'Slack.app',              unit = units.right,         screen = 'Color LCD'   }
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
hs.hotkey.bind(mash, 'right', function() hs.window.focusedWindow():move(units.right, nil, true) end)
hs.hotkey.bind(mash, 'left',  function() hs.window.focusedWindow():move(units.left, nil, true) end)
hs.hotkey.bind(mash, 'up',    function() hs.window.focusedWindow():move(units.top, nil, true) end)
hs.hotkey.bind(mash, 'down',  function() hs.window.focusedWindow():move(units.bottom, nil, true) end)
hs.hotkey.bind(mash, '1',     function() hs.window.focusedWindow():move(units.topleft, nil, true) end)
hs.hotkey.bind(mash, '2',     function() hs.window.focusedWindow():move(units.topright, nil, true) end)
hs.hotkey.bind(mash, '3',     function() hs.window.focusedWindow():move(units.bottomleft, nil, true) end)
hs.hotkey.bind(mash, "4",     function() hs.window.focusedWindow():move(units.bottomright, nil, true) end)
hs.hotkey.bind(mash, 'm',     function() hs.window.focusedWindow():move(units.maximum, nil, true) end)
hs.hotkey.bind(mash, 'n',     moveToNextScreen)
hs.hotkey.bind(mash, '0',     function() runLayout(layouts.work) end)