{ pkgs, ... }:
{
  #####################################
  ## XDG PORTAL (X11 Only)
  #####################################
  # Apps to System Communication
  # OpenFolder, ScreenSharing, OpenURL, Notif, Printing..
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-cosmic
      # xdg-desktop-portal-gnome
      # xdg-desktop-portal-luminous
      # xdg-desktop-portal-phosh
      # xdg-desktop-portal-termfilechooser
      # xdg-desktop-portal-xapp
      # xdg-desktop-portal-wlr
      # xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [ "gtk" ];
        # Eksplisit assign per-interface agar tidak ambigu
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.AppChooser"  = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot"  = [ "gtk" ];
        "org.freedesktop.impl.portal.OpenURI"     = [ "gtk" ];
      };
    };
    bspwm = {
      default = [ "gtk" ];
    };
  };
}
