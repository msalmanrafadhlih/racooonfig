{
  mkSymlink,
  pkgs,
  config,
  lib,
  ...
}:
let
  configs = {
    "alacritty/alacritty.toml" = "alacritty.toml";
    "alacritty/fonst.toml" = "fonts.toml";
  };
  cfg = config.racooonfig;
in
{

  config = lib.mkIf (cfg.homeManager && builtins.elem "alacritty" cfg.listConfigurations) {
    xdg.configFile = mkSymlink {
      target = "alacritty";
    } configs;

    home.packages = with pkgs; [
      alacritty
    ];
  };

}
