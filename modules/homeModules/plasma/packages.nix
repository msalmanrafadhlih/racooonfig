# packages.nix
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
  home.packages =
    with pkgs;
    [
      dconf-editor

      glib
      gsettings-desktop-schemas
      gsettings-qt

    ]
    ++ (lib.optionals (builtins.elem "macos-kdeplasma" cfg.listConfigurations) [
      sassc
      rsync
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
      kdePackages.kdbusaddons
      # kdePackages.qttools

      (writeShellScriptBin "qdbus" ''
        exec ${kdePackages.qttools}/bin/qdbus "$@" 2>/dev/null || true
      '')
      (writeShellScriptBin "qdbus6" ''
        exec ${kdePackages.qttools}/bin/qdbus6 "$@" 2>/dev/null || true
      '')

      gnome-weather
      gnome-maps
      gnome-calendar
      gnome-clocks
    ]);
}
