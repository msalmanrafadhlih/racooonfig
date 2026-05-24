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
  # Then use with `nixos-rebuild switch --specialisation gamemode`
  config = lib.mkIf (cfg.homeManager && builtins.elem "gamemode" cfg.listConfigurations) {
    # Well, My laptop sekarang kentang! dan butuh minimal usage.
    # Execute this cmd jika perangkat kalian support gaming
    # or adds your gaming configurations here 'its up to you..'

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        fps_limit = 144;
        cpu_temp = true;
        gpu_temp = true;
        ram = true;
        fps = true;
        frame_timing = 1;
      };
    };

    # # to use gamemode with steam edit launch options inside
    # # game -> general -> launch options -> `gamemoderun %command%`
    home.packages = with pkgs; [
      lutris
      heroic
      winboat
    ];
  };
}
