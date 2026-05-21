{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (builtins.elem "bottom" cfg.listConfigurations) {

    programs.bottom = {
      enable = true;
    };

    catppuccin.bottom = {
      enable = true;
      flavor = "mocha";
    };

    xdg.desktopEntries.bottom = {
      name = "bottom";
      genericName = "System Monitor";
      comment = "A customizable cross-platform graphical process/system monitor for the terminal.";
      exec = "kitty -e btm";
      terminal = false;
      type = "Application";
      icon = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/bluefish.svg";
      categories = [
        "Utility"
        "System"
        "ConsoleOnly"
        "Monitor"
      ];
      startupNotify = false;
    };
  };

}
