{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (builtins.elem "vscode" cfg.listConfigurations) {
    home.packages = with pkgs; [
      vscode
    ];
  };
}
