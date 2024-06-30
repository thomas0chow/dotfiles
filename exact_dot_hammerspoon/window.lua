-- half of screen
hs.hotkey.bind({ "alt", "cmd" }, "h", function() hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 1 }) end)
hs.hotkey.bind({ "alt", "cmd" }, "l", function() hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 1 }) end)
hs.hotkey.bind({ "alt", "cmd" }, "k", function() hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 0.5 }) end)
hs.hotkey.bind({ "alt", "cmd" }, "j", function() hs.window.focusedWindow():moveToUnit({ 0, 0.5, 1, 0.5 }) end)

-- quarter of screen
hs.hotkey.bind({ "shift", "alt", "cmd" }, "h", function() hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 0.5 }) end)
hs.hotkey.bind({ "shift", "alt", "cmd" }, "l",
    function() hs.window.focusedWindow():moveToUnit({ 0.5, 0.5, 0.5, 0.5 }) end)
hs.hotkey.bind({ "shift", "alt", "cmd" }, "k", function() hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 0.5 }) end)
hs.hotkey.bind({ "shift", "alt", "cmd" }, "j", function() hs.window.focusedWindow():moveToUnit({ 0, 0.5, 0.5, 0.5 }) end)

-- full screen
hs.hotkey.bind({ "alt", "cmd" }, "f", function() hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 }) end)

-- center screen
hs.hotkey.bind({ "alt", "cmd" }, "c", function() hs.window.focusedWindow():centerOnScreen() end)


-- close focus windows
hs.hotkey.bind({ "alt", "cmd" }, "q", function() hs.window.focusedWindow():close() end)

-- minimize focused windows
hs.hotkey.bind({ "cmd" }, "m", function() hs.window.focusedWindow():minimize() end)

-- switch focus windows
hs.hotkey.bind({ "cmd" }, "l", function() hs.window.focusedWindow():focusWindowEast() end)
hs.hotkey.bind({ "cmd" }, "h", function() hs.window.focusedWindow():focusWindowWest() end)
hs.hotkey.bind({ "cmd" }, "j", function() hs.window.focusedWindow():focusWindowSouth() end)
hs.hotkey.bind({ "cmd" }, "k", function() hs.window.focusedWindow():focusWindowNorth() end)

-- focus on frontmost window
hs.hotkey.bind({ "cmd" }, "space", function() hs.window.frontmostWindow():focus() end)

-- move between screen
hs.hotkey.bind({ "shift", "cmd" }, "l", function()
    local win = hs.window.focusedWindow()
    local next = win:screen():toEast()
    if next then
        win:moveToScreen(next, true)
    end
end)
hs.hotkey.bind({ "shift", "cmd" }, "h", function()
    local win = hs.window.focusedWindow()
    local next = win:screen():toWest()
    if next then
        win:moveToScreen(next, true)
    end
end)
