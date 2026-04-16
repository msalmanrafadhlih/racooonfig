{ mkSymlink, ... }:
let
  configs = {
    config = "bat/config";
  };

in
{
  xdg.configFile = mkSymlink {
    target = "bat";
  } configs;
}
