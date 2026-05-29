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
  # Apps to System Communication
  # OpenFolder, ScreenSharing, OpenURL, Notif, Printing..
  config = lib.mkIf cfg.enable {

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
      "/share/thumbnailers"
      "/share/gsettings-schemas"
    ];

    xdg.portal = {
      enable = lib.mkDefault true;
      xdgOpenUsePortal = lib.mkDefault true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        # xdg-desktop-portal-cosmic
        # xdg-desktop-portal-gnome
        # xdg-desktop-portal-luminous
        # xdg-desktop-portal-phosh
        # xdg-desktop-portal-termfilechooser
        # xdg-desktop-portal-xapp
        # xdg-desktop-portal-wlr
      ];
      config = {
        common = {
          default = [ "gtk" ];
        };

        bspwm = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.AppChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gtk" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
        };

        Hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.AppChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
        };
      };
    };
  };
}
