{ config, lib, pkgs, ... }: let cfg = config.racooonfig;
in {
  config = lib.mkIf (cfg.homeManager && builtins.elem "vscode" cfg.listConfigurations) {
    home.packages = with pkgs; [
      vscode
    ];
  };
}
