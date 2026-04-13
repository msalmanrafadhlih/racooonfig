{ pkgs, config, inputs, ... }: {
  # Target Applications
  imports = [
    inputs.stylix.nixosModules.default

    ./targets.nix
  ];

  stylix = {
    enable = true;

    # Whether to enable targets by default.
    # When this is false, all targets are disabled unless explicitly enabled.
    autoEnable = true;

    # Whether to enable theming for packages via overlays.
    # Default : config.stylix.autoEnable
    overlays.enable = true; # boolean

    # Whether to check that the Stylix release matches the releases of NixOS, Home Manager, and nix-darwin.
    # If this option is enabled and a mismatch is detected,
    # a warning will be printed when the user configuration is being built.
    enableReleaseChecks = true;

    polarity = "dark"; # "dark","light"

    ## Attributes defining the systemwide cursor.
    ## Set either all or none of these attributes.
    cursor = {
      name = "Kafka";
      size = 24;
      package = pkgs.cursor-memes;
    };

    ##########
    ## Fonts Theming
    fonts = {
      sizes = {
        applications = 10;
        desktop = 10;
        popups = config.stylix.fonts.sizes.desktop;
        terminal = config.stylix.fonts.sizes.applications;
      };

      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };

      monospace = {
        name = "JetBrainsMono Nerd Font"; # Font coding paling enak
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      sansSerif = {
        name = "Inter"; # UI aplikasi jadi terlihat modern
        package = pkgs.inter;
      };

      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };
    };

    #########
    # Icons Theming
    icons = {
      enable = true;
      # Nama di sini harus sesuai dengan nama folder di dalam /share/icons/
      # ls $(nix-build -E "with import <nixpkgs> {}; vimix-icon-theme")/share/icons
      dark = "Vimix-ruby-dark";
      light = "Vimix-ruby";
      package = pkgs.vimix-icon-theme;
    };
  };
}

