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
  config = lib.mkIf (cfg.enable && cfg.gamemode.enable) {

    programs.gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        cpu.park_cores = "no";
        general = {
          renice = 10;
          softrealtime = "auto";
        };
        custom.start = ''${pkgs.dunst}/bin/dunstify "GameMode" "enabled"'';
        custom.end = ''${pkgs.dunst}/bin/dunstify "GameMode" "disabled"'';
      };
    };

    programs.steam = {
      enable = builtins.elem "steam" cfg.gamemode.programs;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
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
  };
}
