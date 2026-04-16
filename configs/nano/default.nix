{ mkSymlink, ... }:

let
  configs = {
		".config/nano/extra"   = "extra";
		".config/nano/default" = "default";

		".nanorc" = "nanorc";
  };

in

{
  home.file = mkSymlink {
    target = "nano";
  } configs;
}
