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
      foot

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
      ripgrep
      socat
      yq-go

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

      # (pkgs.symlinkJoin {
      #   name = "quickshell-with-qt-modules";
      #   paths = [ pkgs.quickshell ];
      #   buildInputs = [ pkgs.qt6.qtbase ];
      #   nativeBuildInputs = [ pkgs.qt6.wrapQtAppsHook ];

      #   qtWrapperArgs = [
      #     "--prefix QML2_IMPORT_PATH : ${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
      #     "--prefix QML2_IMPORT_PATH : ${pkgs.kdePackages.qt5compat}/lib/qt-6/qml"
      #     "--prefix QML2_IMPORT_PATH : ${pkgs.kdePackages.qtwebengine}/lib/qt-6/qml"
      #     "--prefix QML2_IMPORT_PATH : ${pkgs.kdePackages.qtwebsockets}/lib/qt-6/qml"
      #     "--prefix QML2_IMPORT_PATH : ${pkgs.kdePackages.qtsvg}/lib/qt-6/qml"
      #   ];
      # })

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
      kdePackages.qtwebengine
      kdePackages.qtwebsockets
      kdePackages.qtsvg
      kdePackages.qtdeclarative # qt6-declarative di dokumen

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
      zbar

      ##################################################
      # ---------------- DEVELOPMENT ----------------- #
      ##################################################
      jdk8
      pkgsCross.mingwW64.stdenv.cc

      ##################################################
      # ---------------- UTILITIES ------------------- #
      ##################################################
      bottles
      cliphist
      obsidian
      p7zip
      taskwarrior3
      wmctrl

    ];

    fonts.packages = with pkgs; [
      udev-gothic-nf
      noto-fonts
      liberation_ttf
      iosevka
    ];
  };
}
