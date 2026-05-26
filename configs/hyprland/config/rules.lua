-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ◈ WINDOW & LAYER RULES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

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

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name  = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name  = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

-- xwayland {
--     enabled = false
-- }

-- # ─────────────────────────────
-- # Layer rules (OSD / overlays)
-- # ─────────────────────────────
-- # layerrule = noanim, ^(volume_osd)$
-- # layerrule = noanim, ^(brightness_osd)$
-- # layerrule = noanim, hyprpicker
-- # layerrule = noanim, qsdock
-- # layerrule = blur, ext-session-lock
-- # layerrule = ignorealpha 0.2, ext-session-lock

-- # ─────────────────────────────
-- # Window rules
-- # ─────────────────────────────

--  workspace = w[tv1], gapsout:0, gapsin:0
--  workspace = f[1], gapsout:0, gapsin:0
--  windowrule {
--      name = no-gaps-wtv1
--      match:float = false
--      match:workspace = w[tv1]

--      border_size = 0
--      rounding = 0
--  }

--  windowrule {
--      name = no-gaps-f1
--      match:float = false
--      match:workspace = f[1]

--      border_size = 0
--      rounding = 0
--  }

-- windowrule {
--     # Ignore maximize requests from all apps. You'll probably like this.
--     name = suppress-maximize-events
--     match:class = .*

--     suppress_event = maximize
-- }

-- # windowrule {
-- #     # Fix some dragging issues with XWayland
-- #     name = fix-xwayland-drags
-- #     match:class = ^$
-- #     match:title = ^$
-- #     match:xwayland = true
-- #     match:float = true
-- #     match:fullscreen = false
-- #     match:pin = false

-- #     no_focus = true
-- # }

-- # Hyprland-run windowrule
-- windowrule {
--     name = move-hyprland-run

--     match:class = hyprland-run

--     move = 20 monitor_h-120
--     float = yes
-- }

-- # ───────── CS2 ─────────
-- # windowrulev2 = immediate, class:^(cs2)$
-- # windowrulev2 = keepaspectratio, class:^(cs2)$

-- # # ───────── App Launcher ─────────
-- # windowrulev2 = float, title:^(app-launcher)$
-- # windowrulev2 = center, title:^(app-launcher)$
-- # windowrulev2 = size 1200 600, title:^(app-launcher)$
-- # windowrulev2 = animation slide, title:^(app-launcher)$

-- # # ───────── MASTER QUICKSHELL CONTAINER ─────────
-- # # All widgets now live inside this single, shape-shifting window.
-- # windowrulev2 = float, title:^(qs-master)$
-- # windowrulev2 = noshadow, title:^(qs-master)$
-- # windowrulev2 = noborder, title:^(qs-master)$
-- # windowrulev2 = noinitialfocus, title:^(qs-master)$

