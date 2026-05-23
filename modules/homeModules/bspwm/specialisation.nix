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
  imports = [ ../../../configs/bspwm ];

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

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = "1";
          MANGOHUD_CONFIG = "read_cfg,no_display";
          GAMEMODERUN = "1";
          AMD_VULKAN_ICD = "RADV";
          VKD3D_CONFIG = "dxr,dxr11";
          PROTON_ADD_CONFIG = "fsr4rdna3";
          PROTON_LOCAL_SHADER_CACHE = "1";
          MESA_SHADER_CACHE_MAX_SIZE = "16G";
          WINE_VK_VULKAN_ONLY = "1";
          MESA_GLSL_CACHE_MAX_SIZE = "16G";
          WINEDLLOVERRIDES = "dinput8,dxgi,dsound=n,b";
        };
      };
    };

    # # to use gamemode with steam edit launch options inside
    # # game -> general -> launch options -> `gamemoderun %command%`
    home.packages = with pkgs; [
      lutris
      gamemode
      heroic
      steam-run
      winboat
    ];
  };
}
