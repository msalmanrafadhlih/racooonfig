-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  ◈ AUTOSTART
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
