{
  mkSymlink,
  lib,
  config,
  ...
}:

let
  configs = {
    ".config/nano/extra" = "extra";
    ".config/nano/default" = "default";

    ".nanorc" = "nanorc";
  };
  cfg = config.racooonfig;
in

{
  config = lib.mkIf (builtins.elem "nano" cfg.listConfigurations) {
    home.file = mkSymlink {
      target = "nano";
    } configs;
  };

}
