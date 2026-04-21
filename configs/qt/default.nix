{ mkSymlink, ... }: let

  configs = {
   "qt5ct/qt5ct.conf" = "qt5ct.conf";
   "qt6ct/qt6ct.conf" = "qt6ct.conf";
  };
in {
  
  # QT config (biar ikut icon/theme)
  # xdg.configFile = mkSymlink {
  #   target = "qt";
  # } configs;

  qt = {
    enable = true;
    kvantum.enable = true;
  };
}
