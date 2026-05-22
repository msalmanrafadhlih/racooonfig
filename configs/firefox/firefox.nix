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
  config = lib.mkIf (builtins.elem "firefox" cfg.listConfigurations) {
    xdg.desktopEntries.firefox_focus = {
      name = "Firefox Focus";
      genericName = "Web Browser";
      comment = "New Private Window";
      exec = "firefox --private-window %U";
      terminal = false;
      type = "Application";
      icon = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/firefox-developer.svg";
      categories = [
        "Network"
        "WebBrowser"
      ];
      startupNotify = true;
    };
  };
}
