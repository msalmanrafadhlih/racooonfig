-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  ◈ SETTINGS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 4,


		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		border_size = 2,
		resize_on_border = true,
    extend_border_grab_area = 30,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = true,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 8,
			passes = 2,
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
    -- pseudotile = true, -- Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
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


-- general {
--     border_size = 2
--     gaps_in = 4
--     gaps_out = 4
--     float_gaps = 6

--     # Set to true enable resizing windows by clicking and dragging on borders and gaps
--     resize_on_border = true
--     extend_border_grab_area = 30

--     col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
--     col.inactive_border = rgba(595959aa)

--     # col.active_border = $active_border
--     # col.inactive_border = $inactive_border

--     # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
--     allow_tearing = true
--     layout = dwindle
-- }

-- decoration {
--     rounding = 3
--     rounding_power = 2

--     active_opacity = 1.0
--     inactive_opacity = 1.0

--     blur {
--         enabled = true
--         size = 8
--         passes = 2
--         new_optimizations = true

--         vibrancy = 0.1696
--     }
--     shadow {
--         enabled = false
--         range = 4
--         render_power = 3
--         color = rgba(1a1a1aee)
--     }
-- }

-- input {
--     kb_layout = us, ru
--     kb_options = grp:alt_shift_toggle
--     kb_variant = 
--     kb_model = 
--     kb_rules = 
--     accel_profile = flat

--     # Mengatur jeda awal sebelum karakter berulang (dalam milidetik)
--     # Nilai 250 - 300 ms adalah angka yang ideal dan responsif
--     repeat_delay = 250

--     # Mengatur berapa banyak karakter yang keluar per detik saat tombol ditahan
--     # Nilai 35 - 40 membuat penghapusan teks atau pengetikan berulang sangat cepat
--     repeat_rate = 40

--     follow_mouse = 1

--     sensitivity = 0.5 # -1.0 - 1.0, 0 means no modification.

--     touchpad {
--         natural_scroll = true
--     }
-- }

-- misc {
--     force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
--     focus_on_activate = true
--     font_family = JetBrains Mono
--     disable_hyprland_logo = false
--     disable_splash_rendering = true
-- }

-- # See https://wiki.hypr.land/Configuring/Master-Layout/ for more
-- master {
--     new_status = master
-- }

-- dwindle {
--     pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
--     preserve_split = true # You probably want this
-- }

-- animations {
--     enabled = yes
--     bezier = myBezier, 0.05, 0.9, 0.1, 1.05
--     animation = windows, 1, 5, myBezier, popin 80%
--     animation = windowsOut, 1, 5, myBezier, popin 80%
--     animation = layers, 1, 5, myBezier, fade
--     animation = layersIn, 1, 5, myBezier, fade
--     animation = layersOut, 1, 5, myBezier, fade
--     animation = fade, 1, 5, myBezier
--     animation = workspaces, 1, 5, myBezier, slide
--     animation = specialWorkspaceIn, 1, 5, myBezier, fade
--     animation = specialWorkspaceOut, 1, 5, myBezier, fade
-- }

-- # Example per-device config
-- # See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
-- device {
--     name = epic-mouse-v1
--     sensitivity = -0.5
-- }
