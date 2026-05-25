{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.enable && builtins.elem "hyprland" cfg.windowManager) {
    environment.systemPackages = with pkgs; [
      ##################################################
      # ----------------- SYSTEM --------------------- #
      ##################################################
      acpi
      bc
      file
      inotify-tools
      killall
      lm_sensors
      power-profiles-daemon
      tree
      wget

      ##################################################
      # ---------------- TERMINAL -------------------- #
      ##################################################
      btop
      cava
      cbonsai
      clock-rs
      fastfetch
      fortune
      lavat
      pipes

      ##################################################
      # ---------------- SHELL DEV ------------------- #
      ##################################################
      direnv
      fd
      fzf
      git
      jq
      neovim
      ripgrep
      socat
      yq-go

      # ======= LANGUAGE / COMPILER
      luajit        # High-performance Lua implementation
      # Python interpreter
      python311
      python312
      python313
      python314
      python315

      ##################################################
      # ---------------- NETWORK --------------------- #
      ##################################################
      iw
      networkmanager
      networkmanager_dmenu

      ##################################################
      # --------------- BLUETOOTH -------------------- #
      ##################################################
      bluez

      ##################################################
      # ----------------- AUDIO ---------------------- #
      ##################################################
      alsa-utils
      ladspa-sdk
      ladspaPlugins
      pamixer
      pavucontrol
      easyeffects
      playerctl
      pulseaudio

      ##################################################
      # ---------------- DISPLAY --------------------- #
      ##################################################
      brightnessctl
      libnotify

      ##################################################
      # ---------------- WAYLAND --------------------- #
      ##################################################
      grim
      satty
      slurp
      swappy
      awww
      wl-clipboard
      wl-screenrec
      xdg-desktop-portal-gtk

      ##################################################
      # ---------------- HYPRLAND -------------------- #
      ##################################################
      eww
      mpvpaper
      quickshell

      ##################################################
      # ---------------- GTK / QT -------------------- #
      ##################################################
      adw-gtk3
      adwaita-icon-theme
      gnome-shell-extensions
      gnome-tweaks
      gtk3
      libsForQt5.qt5ct
      qt6.qtmultimedia
      qt6.qt5compat
      qt6.qtwebengine
      qt6.qtwebsockets
      qt6Packages.qt6ct

      ##################################################
      # ---------------- MEDIA ----------------------- #
      ##################################################
      ffmpeg
      glaxnimate
      gpu-screen-recorder
      imagemagick
      inkscape
      mpv
      obs-studio
      zbar

      ##################################################
      # ---------------- OFFICE ---------------------- #
      ##################################################
      hunspell
      libreoffice-qt
      onlyoffice-desktopeditors
      papers

      ##################################################
      # ---------------- INTERNET -------------------- #
      ##################################################
      (wrapFirefox (pkgs.firefox-unwrapped.override {
        pipewireSupport = true;
      }) { })
      qbittorrent
      telegram-desktop

      ##################################################
      # ---------------- DEVELOPMENT ----------------- #
      ##################################################
      jdk8
      pkgsCross.mingwW64.stdenv.cc
      steam-run

      ##################################################
      # ---------------- UTILITIES ------------------- #
      ##################################################
      bottles
      cliphist
      obsidian
      p7zip
      taskwarrior3
      wmctrl

      ##################################################
      # ---------------- TERMINAL -------------------- #
      ##################################################
      kitty
    ];

    fonts.packages = with pkgs; [
      udev-gothic-nf
      noto-fonts
      liberation_ttf
      iosevka
    ];
  };
}
