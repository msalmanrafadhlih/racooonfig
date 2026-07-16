{
  mkSymlink,
  lib,
  config,
  ...
}:

let
  configs = {
    ".bunfig.toml" = "bunfig.toml";
  };
  username = config.home.username;
in

{
  config = lib.mkIf (username == "tquilla") {
    home.file = mkSymlink {
      target = "development";
    } configs;
  };
}
