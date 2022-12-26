-- half of screen
hs.hotkey.bind({"alt", "cmd"}, "h", function() hs.window.focusedWindow():moveToUnit({0, 0, 0.5, 1}) end)
hs.hotkey.bind({"alt", "cmd"}, "l", function() hs.window.focusedWindow():moveToUnit({0.5, 0, 0.5, 1}) end)
hs.hotkey.bind({"alt", "cmd"}, "k", function() hs.window.focusedWindow():moveToUnit({0, 0, 1, 0.5}) end)
hs.hotkey.bind({"alt", "cmd"}, "j", function() hs.window.focusedWindow():moveToUnit({0, 0.5, 1, 0.5}) end)

-- quarter of screen
hs.hotkey.bind({"shift","alt", "cmd"}, "h", function() hs.window.focusedWindow():moveToUnit({0, 0, 0.5, 0.5}) end)
hs.hotkey.bind({"shift","alt", "cmd"}, "l", function() hs.window.focusedWindow():moveToUnit({0.5, 0.5, 0.5, 0.5}) end)
hs.hotkey.bind({"shift","alt", "cmd"}, "k", function() hs.window.focusedWindow():moveToUnit({0.5, 0, 0.5, 0.5}) end)
hs.hotkey.bind({"shift","alt", "cmd"}, "j", function() hs.window.focusedWindow():moveToUnit({0, 0.5, 0.5, 0.5}) end)

-- full screen
hs.hotkey.bind({"alt", "cmd"}, "f", function() hs.window.focusedWindow():moveToUnit({0, 0, 1, 1}) end)

-- center screen
hs.hotkey.bind({"alt", "cmd"}, "c", function() hs.window.focusedWindow():centerOnScreen() end)


-- close focus windows
hs.hotkey.bind({"alt", "cmd"}, "q", function() hs.window.focusedWindow():close() end)

-- minimize focused windows
hs.hotkey.bind({"cmd"}, "m", function() hs.window.focusedWindow():minimize() end)

-- windows sizing
hs.hotkey.bind({"alt", "cmd"}, "s", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	
	f.w = max.w / 2
	f.h = max.h / 2
	win:setFrame(f)
	end
)

-- switch focus windows
hs.hotkey.bind({"cmd"}, "l", function() hs.window.focusedWindow():focusWindowEast() end)
hs.hotkey.bind({"cmd"}, "h", function() hs.window.focusedWindow():focusWindowWest() end)
hs.hotkey.bind({"cmd"}, "j", function() hs.window.focusedWindow():focusWindowSouth() end)
hs.hotkey.bind({"cmd"}, "k", function() hs.window.focusedWindow():focusWindowNorth() end)

-- move between screen
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", function()
		local win = hs.window.focusedWindow()
		local next = win:screen():toEast()
		if next then
				win:moveToScreen(next, true)
		end
end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "h", function()
		local win = hs.window.focusedWindow()
		local next = win:screen():toWest()
		if next then
				win:moveToScreen(next, true)
		end
end)
