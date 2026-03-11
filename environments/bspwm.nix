{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ======== BSPWM Stuff
    polybarFull
    sxhkd
    picom
    rofi
    eww
    i3lock-color
    
    # ======== TOOLS
    sound-theme-freedesktop
    libcanberra-gtk3
    mpv-unwrapped
    brightnessctl
    flameshot
    imagemagick
    clipmenu
    killall
    xclip # Clipboard
    dunst
	  kdocker
		qview
    maim
    feh
    bc

    # ======== UTILS
    imlib2
    xinit
    xsetroot
    xrandr
    xinput
    pamixer
    xdotool
    xcolor
  ];

	security.pam.services.i3lock.enable = true;
	security.pam.services.i3lock = { };
	security.pam.services.i3lock.text = "auth include login";

  services = {
  #############################
  ## WINDOW MANAGER SETTINGS
  #############################
    xserver = {
        enable = true;
        # xkb = {
        #   layout = "us";
        # };
        windowManager = {
            bspwm.enable = true;
        };
        autoRepeatDelay = 300;
        autoRepeatInterval = 35;
        displayManager = {
        	startx.enable = true;
        	lightdm = {
        		enable = true;
		        background = builtins.fetchurl {
		          url = "https://raw.githubusercontent.com/msalmanrafadhlih/Nixos-Dotsfile/refs/heads/main/config/Assets/Wallpaper/wallpaper8.jpeg";
		          sha256 = "sha256-VZp1wy2N0GApt48ILRY+pIAhAjCt02GmqmxHRTWAEoA=";
		        };
        	};
        };
    };

  ###################################
  ## XDG + GTK SETTINGS
  #####################################
	dbus.enable = true;
    dbus.packages = with pkgs; [ dconf ];
		udisks2.enable = true;
		gvfs = {
	        enable = true;
	        package = pkgs.gnome.gvfs;
	    };
  };

  ###################################
  ## THUNAR OPTIMALIZATION
  #####################################
  programs = {
		thunar = {
			enable = true;
			plugins = with pkgs; [
				thunar-volman
				thunar-dropbox-plugin
				thunar-vcs-plugin
				thunar-media-tags-plugin
			];
		};
  };
  services.tumbler.enable = true; # thumbnails di Thunar  

  #####################################
  ## XDG PORTAL (X11 Only)
  #####################################
	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = true;
		extraPortals = with pkgs; [
		  xdg-desktop-portal-gtk
		];
		config = {
		  common = {
		    default = ["gtk"];
		  };
		};
	};
	environment.sessionVariables = {
		XDG_CURRENT_DESKTOP = "bspwm";
		XDG_SESSION_TYPE = "x11";
	};
	xdg.mime.enable = true;
	# xdg.mime.defaultApplications = { };
	
  #####################################
  ## ⚡ Nix Daemon & Build Optimization
  #####################################
  nix.settings = {
    extra-experimental-features = ["nix-command" "flakes"];
    # pastikan sama seperti di nixConfig
    extra-substituters = [
      "https://spicetify-nix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "spicetify-nix.cachix.org-1:jjnwULkvMdu0E5KGBbtgrISEfDdJTGSZ4ATkiFzZn5I="
    ];
    auto-optimise-store = true;
    warn-dirty = false;
  };
}
