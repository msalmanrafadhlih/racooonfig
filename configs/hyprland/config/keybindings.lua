-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  ◈ KEYBINDINGS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local mainMod = "SUPER"


-- Mouse & Window Drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Window Management

-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Resize window
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -50 0"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 50 0"))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -50"))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 50"))

-- Move window
hl.bind(mainMod .. " + CTRL + left", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))

-- Window actions
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.float({ action = "toggle" }))

-- Workspace cycling
hl.bind(mainMod .. " + H", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "e+1" }))

-- System & Hardware
hl.bind(
	"Caps_Lock",
	hl.dsp.exec_cmd("sleep 0.1 && swayosd-client --caps-lock"),
	{ locked = true }
)
hl.bind(
	"ALT + SHIFT_L + comma",
	hl.dsp.exec_cmd("swayosd-client --brightness lower"),
	{ locked = true, repeating = true }
)
hl.bind(
	"ALT + SHIFT_L + period",
	hl.dsp.exec_cmd("swayosd-client --brightness raise"),
	{ locked = true, repeating = true }
)

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"), { locked = true })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh --edit"), { locked = true })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh --full"), { locked = true })
hl.bind(
	mainMod .. " + SHIFT + Print",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh --full --edit"),
	{ locked = true }
)

-- Lock
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("~/.config/hypr/scripts/lock.sh"))

-- Media & Audio
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
	{ locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
	{ locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
	{ locked = true, repeating = true }
)
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("swayosd-client --output-volume raise"))

-- Applications & Launchers
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("open --terminal"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("open --filemanager"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("open --discord"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("open --spotify"))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("flatpak run app.zen_browser.zen"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("open --editor"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("open --switcher"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("open --powermenu"))
hl.bind(mainMod .. " + ALT_L + SPACE", hl.dsp.exec_cmd("open --bookmarks"))
hl.bind(mainMod .. " + ALT_L + B", hl.dsp.exec_cmd("open --btop"))
hl.bind(mainMod .. " + ALT_L + T", hl.dsp.exec_cmd("open --switchterminal"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("open --yazi"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("open --music"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("open --terminalIDE"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("open --gemini"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("open --claude"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("open --chatgpt"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("open --telegram"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("open --musictagger"))
hl.bind("ALT + W", hl.dsp.exec_cmd("open --rice"))
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd("open --ulauncher"))
hl.bind(
	mainMod .. " + B",
	hl.dsp.exec_cmd([[
$BROWSER \
--disable-breakpad --disable-logging \
--disable-crash-reporter --disk-cache-dir=/tmp \
--disk-cache-size=104857600 &
]])
)

-- Quickshell Controls
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle monitors"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle applauncher"))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle clipboard"))
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle settings"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle battery"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle calendar"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle network"))
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle focustime"))
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle volume"))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle guide"))
hl.bind(mainMod .. " + F7", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle music"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle wallpaper"))
hl.bind(
	"CTRL + SUPER + ALT + RETURN",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/reload.sh")
)

-- workspaces
for i = 1, 10 do
	local key = i % 10

	hl.bind(
		mainMod .. " + " .. key,
		hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh " .. i)
	)

	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh " .. i .. " move")
	)
end

