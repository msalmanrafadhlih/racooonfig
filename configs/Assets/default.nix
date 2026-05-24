# ./modules/applications.nix
{ mkSymlink, lib, config, ... }: let locals = import ./launchers.nix;
  cfg = config.racooonfig;
in {
  config = lib.mkIf cfg.homeManager {
    home.file = mkSymlink { } locals;
  };
}
