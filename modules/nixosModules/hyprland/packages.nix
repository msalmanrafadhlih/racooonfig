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
      luajit # High-performance Lua implementation
      python3 # Python interpreter

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

      (quickshell.override {
        # Memaksa quickshell membawa qtmultimedia ke dalam runtime-nya
        libs = with pkgs; [
          qt6.qtmultimedia
          qt6.qt5compat
          qt6.qtwebengine
          qt6.qtwebsockets
        ];
      })

      # #################################################
      # ---------------- GTK / QT -------------------- #
      ##################################################
      adw-gtk3
      adwaita-icon-theme
      gnome-shell-extensions
      gnome-tweaks
      gtk3

      kdePackages.qtmultimedia
      kdePackages.qt5compat
      kdePackages.qtsvg
      kdePackages.qtdeclarative # qt6-declarative di dokumen

      # GStreamer Plugins (Wajib untuk video background di qylock)
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav

      libsForQt5.qt5ct
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
