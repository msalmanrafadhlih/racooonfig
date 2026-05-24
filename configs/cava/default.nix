{
  mkSymlink,
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.racooonfig;
  cava-dynamic = pkgs.writeShellScriptBin "cava" ''
    # Ensure the cava config directory exists
    mkdir -p ~/.config/cava
    
    # Combine the static Nix config and the dynamic Matugen colors
    cat ~/.config/cava/config_base ~/.config/cava/colors > ~/.config/cava/config 2>/dev/null
    
    # Launch the actual CAVA binary
    exec ${pkgs.cava}/bin/cava "$@"
  '';

  configs = {
    "cava/config_base" = "config";
  };
in

{
  config = lib.mkIf (cfg.homeManager && builtins.elem "cava" cfg.listConfigurations) {
    home.packages = [
      (lib.hiPrio cava-dynamic)
    ];
    xdg.configFile = mkSymlink {
      target = "cava";
    } configs;
  };
}
