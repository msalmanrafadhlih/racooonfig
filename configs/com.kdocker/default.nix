{ mkSymlink, ... }:

let
  configs = {
		"com.kdocker/icons" = "icons";
		"com.kdocker/KDocker.conf" = "KDocker.conf";
  };
in

{
  xdg.configFile = mkSymlink {
    target = "com.kdocker";
  } configs;
}
