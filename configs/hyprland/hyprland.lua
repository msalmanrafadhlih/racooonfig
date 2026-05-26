-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "foot"
local fileManager = "thunar"
local menu        = "hyprlauncher"
local browser     = "vivaldi"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("playerctld")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("dbus-update-activation-environment --systemd \
  NIXOS_OZONE_WL \
  XDG_CURRENT_DESKTOP \
  XDG_SESSION_TYPE \
  WAYLAND_DISPLAY")

	-- quickshell
	-- hl.exec_cmd("~/.config/hypr/scripts/settings_watcher.sh &")
	-- hl.exec_cmd("~/.config/hypr/scripts/volume_listener.sh")
	-- hl.exec_cmd("systemctl --user enable --now easyeffects")
	-- hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
	-- hl.exec_cmd("quickshell -p ~/.config/hypr/scripts/quickshell/Shell.qml")
	-- hl.exec_cmd("python3 ~/.config/hypr/scripts/quickshell/focustime/focus_daemon.py &")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- after
hl.env("PATH", "$HOME/.config/bspwm/bin:$PATH")
hl.env("PATH", os.getenv("HOME") .. "/.config/bspwm/bin:" .. os.getenv("PATH"))
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "grp:alt_shift_toggle",
		kb_rules = "",
		accel_profile = "flat",

    -- Mengatur jeda awal sebelum karakter berulang (dalam milidetik)
    -- Nilai 250 - 300 ms adalah angka yang ideal dan responsif
    repeat_delay = 250,

    --  Mengatur berapa banyak karakter yang keluar per detik saat tombol ditahan
    --  Nilai 35 - 40 membuat penghapusan teks atau pengetikan berulang sangat cepat
    repeat_rate = 40,
		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------
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
hl.bind(
	mainMod .. " + B",
	hl.dsp.exec_cmd([[
$BROWSER \
--disable-breakpad --disable-logging \
--disable-crash-reporter --disk-cache-dir=/tmp \
--disk-cache-size=104857600 &
]])
)
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
-- Quickshell Controls
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle monitors"))
hl.bind(
	"CTRL + SUPER + ALT + RETURN",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/reload.sh")
)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle applauncher"))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle clipboard"))
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle settings"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle battery"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle wallpaper"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle calendar"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle network"))
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle focustime"))
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle volume"))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle guide"))
hl.bind(mainMod .. " + F7", hl.dsp.exec_cmd("~/.config/hypr/scripts/qs_manager.sh toggle music"))
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

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
