{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    # spicedSpotify = pkgs.spicetity; # The final spotify package after spicing.
    spicetifyPackage = pkgs.spicetify-cli; # the spicetify-cli packages to use
    spotifyPackage = pkgs.spotify;
    spotifywmPackage = pkgs.spotifywm;

    # -- THEME & COLORSCHEME --
    theme = {
      patches = ''
        {
          "xpui.js_find_8008" = ",(\\w+=)32";
          "xpui.js_repl_8008" = ",$\{1}56";
        };'';
    }
    // spicePkgs.themes.dribbblish;
    colorScheme = "dark";

    # -- EKSTENSI & APLIKASI CUSTOM --
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      popupLyrics
      autoSkipExplicit
      playlistcons
      formatColors
      simpleBeautifulLyrics
      addToQueueTop
      coverAmbience
      allOfArtist
      catJamSynced
    ];

    enabledSnippets = with spicePkgs.snippets; [
      rotatingCoverart
      pointer
    ];

    enabledCustomApps = with spicePkgs.apps; [
      localFiles
      lyricsPlus
      marketplace
      ncsVisualizer
      betterLibrary
    ];

    # Opsi alternatif jika menggunakan tema custom dari GitHub:
    # theme = {
    #   name = "Dribbblish";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "spicetify";
    #     repo = "spicetify-themes";
    #     rev = "02badb180c902f986a4ea4e4033e69fe8eec6a55";
    #     hash = "sha256-KD9VfHtlN0BIHC4inlooxw5XC4xlHNC5evASRqP7pUA=";
    #   };
    # };
    # customColorScheme = {
    #   text = "ffffff";
    #   main = "1e1e2e";
    # };

    # -- FITUR TAMBAHAN --
    # -- TAMPILAN & WINDOW MANAGER --
    # wayland = true; # Mengaktifkan flag native Wayland
    windowManagerPatch = true; # Sangat berguna agar Spotify ter-render dengan baik di Tiling WM
    alwaysEnableDevTools = true;
    experimentalFeatures = true;
    # spotifyLaunchFlags = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
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
