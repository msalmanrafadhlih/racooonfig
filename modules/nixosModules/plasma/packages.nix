{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.racooonfig;
in
with pkgs; [
  # Audio visualizer
  dconf-editor

  glib
  gsettings-desktop-schemas
  gsettings-qt

] ++  (lib.mkIf (builtins.elem "macos-kdeplasma" cfg.listConfigurations) [
  # Dependencies tema
  sassc
  rsync
  libsForQt5.qtstyleplugin-kvantum # kvantum-qt5
  kdePackages.qtstyleplugin-kvantum # versi Qt6


  gnome-weather
  gnome-maps
  gnome-calendar
  gnome-clocks
])
