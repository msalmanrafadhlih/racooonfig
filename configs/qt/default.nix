{ lib, config, ... }: let cfg = config.racooonfig;
in {
  config = lib.mkIf cfg.homeManager {
    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
      kvantum.enable = true;
    };
  };
}
