-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  ◈ SETTINGS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
	general = {
		layout = "scrolling", -- dwindle. master, scrolling, monocle
		locale = "en_US",

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		border_size = 2,
		resize_on_border = true,
    extend_border_grab_area = 15,
    hover_icon_on_border = true,
		gaps_in = 4,
		gaps_out = 4,
		gaps_workspaces = 1,
		float_gaps = 1,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
			nogroup_border = "0xffffaaff",
			nogroup_border_active = "0xffff00ff",
		},

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = true,
		resize_corner = true,
		modal_parent_blocking = true,
		no_focus_fallback = false,
		snap = {
			enabled = true,
			window_gap = 10,
			monitor_gap = 10,
			border_overlap = true,
			respect_gaps = true,
		}
	},

	-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
	decoration = {
		rounding = 10,
		rounding_power = 2.0,
		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0;
		dim_modal = true,
		dim_inactive = false,
		dim_strength = 0.8,
		dim_special = 0.2,
		dim_around = 0.4,
		screen_shader = "",
		border_part_of_window = true,
		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
			color_inactive = nil,
			sharp = false,
			offset = { 0, 0 },
			scale = 1.0,
		},

		glow = {
			enabled = false,
			range = 10,
			render_power = 3,
			color = 0xee1a1a1a,
			color_inactive = nil,
		},

		blur = {
			enabled = true,
			size = 8,
			passes = 2,
			special = false,
			popups = false,
			popups_ignorealpha = 0.2,
			vibrancy = 0.1696,
			vibrancy_darkness = 0.0,
			xray = false,
			noise = 0.0117,
			contrast = 0.8916,
			brightness = 0.8172,
			input_methods = false,
			input_methods_ignorealpha = 0.2,
			ignore_opacity = true,
			new_optimizations = true,
		},
	},

	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},

	-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
	input = {
		kb_model = "",
		kb_layout = "us",
		kb_variant = "",
		kb_options = "grp:alt_shift_toggle",
		kb_rules = "",
		kb_file = "",
    repeat_rate = 40,
    repeat_delay = 250,
		numlock_by_default = "",
		resolve_binds_by_sym = false,

		follow_mouse = 1,
		accel_profile = "adaptive", -- flat, adaptive, custom
		force_no_accel = false,
		rotation = 0,
		left_handed = false,
		scroll_points = nil,
		scroll_method = nil, -- 2fg, edge, on_button_down, no_scroll
		scroll_button = 0,
		scroll_button_lock = false,
		scroll_factor = 1.0,
		natural_scroll = false,
		sensitivity = 0.0, -- -1.0 - 1.0, 0 means no modification.
		follow_mouse_shrink = 0,
		follow_mouse_threshold = 0.0,
		focus_on_close = 2,
		mouse_refocus = true,
		float_switch_override_focus = 1,
		special_fallthrough = false,
		emulate_discrete_scroll = 1,
		off_window_axis_events = 1,

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#touchpad
		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			scroll_factor = 1.0,
			middle_button_emulation = false,
			tap_button_map = nil, -- lrm, lmr
			clickfinger_behavior = false,
			tap_to_click = true,
			drag_lock = 0,
			tap_and_drag = true,
			flip_x = false,
			flip_y = false,
			drag_3fg = 0,
		},

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#touchdevice
		touchdevice = {
			transform = -1,
			-- output = "",
			enabled = true,
		},

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#virtualkeyboard
		virtualkeyboard = {
			share_state = 2,
			release_pressed_on_close = false,
		},

		tablet = {}, -- https://wiki.hypr.land/Configuring/Basics/Variables/#tablet
		tablettool = {}, -- https://wiki.hypr.land/Configuring/Basics/Variables/#tablettool

	},

	-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
	dwindle = {
    -- pseudotile = true, -- Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
		preserve_split = true, -- You probably want this
	},

	-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
	master = {
		new_status = "master",
	},

	-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
	animations = {
		enabled = true,
		workspace_wraparound = false,
	},
})

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })


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


hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
