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
  config = lib.mkIf (builtins.elem "alacritty" cfg.listConfigurations) {
    home.packages = with pkgs; [
      alacritty
    ];
  };

}
