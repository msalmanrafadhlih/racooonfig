{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  ext = {
    addToQueue = {
      src = (pkgs.fetchFromGitHub {
        owner = "Socketlike";
        repo = "spicetify-extensions";
        rev = "a714f85c1a2024be1d44fbff94bacb79e6102f00";
        hash = "sha256-/Sv/RvP1E9CkXwlePhw2bfo3GBmxMJUHF5UJN0Xhr+I=";
      }) + /priority-queue;
      # The actual file name of the extension usually ends with .js
      name = "priority-queue.js";
    };
  };
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
    colorScheme = "custom";
    customColorScheme = {
      text               = "\$\{xrdb:text\}";
      subtext            = "\$\{xrdb:subtext\}";
      sidebar-text       = "\$\{xrdb:sidebar-text\}";
      main               = "\$\{xrdb:main\}";
      sidebar            = "\$\{xrdb:sidebar\}";
      player             = "\$\{xrdb:player\}";
      card               = "\$\{xrdb:card\}";
      shadow             = "\$\{xrdb:shadow\}";
      selected-row       = "\$\{xrdb:selected-row\}";
      button             = "\$\{xrdb:button\}";
      button-active      = "\$\{xrdb:button-active\}";
      button-disabled    = "\$\{xrdb:button-disabled\}";
      tab-active         = "\$\{xrdb:tab-active\}";
      notification       = "\$\{xrdb:notification\}";
      notification-error = "\$\{xrdb:notification-error\}";
      misc               = "\$\{xrdb:misc\}";
    };

    # -- EKSTENSI & APLIKASI CUSTOM --
    enabledExtensions = [
      ext.addToQueue
    ] ++ (with spicePkgs.extensions; [
      adblock
      popupLyrics
      playlistIcons
      formatColors
      beautifulLyrics
      allOfArtist
    ]);

    enabledSnippets = with spicePkgs.snippets; [
      rotatingCoverart
      pointer
    ];

    enabledCustomApps = with spicePkgs.apps; [
      localFiles
      lyricsPlus
      marketplace
      ncsVisualizer
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
