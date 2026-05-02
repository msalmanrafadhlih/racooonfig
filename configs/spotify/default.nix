{ inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  home.packages = [
    pkgs.spicetify-cli
    spicePkgs
  ];

  programs.spicetify = {
	  enable = true;

	  enabledExtensions = with spicePkgs.extensions; [
	    adblock
	  ];
	  enabledCustomApps = with spicePkgs.apps; [
	    newReleases
	  ];
	  enabledSnippets = with spicePkgs.snippets; [
	    rotatingCoverart
	    pointer
	  ];

	  theme = spicePkgs.themes.dribbblish;
	  colorScheme = "Lunar";
  };

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd;
    settings = {
      global = {
        username_cmd = "cat ~/.config/spotify/username";
        password_cmd = "cat ~/.config/spotify/credentials";
        backend = "alsa"; # atau "alsa" kalau kamu pakai ALSA saja
        use_mpris = true;
        device_name = "NixOS-Spotify";
        bitrate = 160;
        volume_normalisation = true;
      };
    };
  };
}
