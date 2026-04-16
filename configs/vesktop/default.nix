{ mkSymlink, ... }:

let
  configs = {
    "vesktop/themes" = "themes";
  };
in
{
  xdg.configFile = mkSymlink {
    target = "vesktop";
  } configs;
}
