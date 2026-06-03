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

      gnome-weather
      gnome-maps
      gnome-calendar
      gnome-clocks
    ]);
}
