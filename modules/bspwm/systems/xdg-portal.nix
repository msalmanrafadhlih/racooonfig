{ pkgs, ... }:{
	  #####################################
	  ## XDG PORTAL (X11 Only)
	  #####################################
	  # Apps to System Communication
	  # OpenFolder, ScreenSharing, OpenURL, Notif, Printing..
		xdg.portal = {
			enable = true;
			xdgOpenUsePortal = true;
			extraPortals = with pkgs; [
			  xdg-desktop-portal-gtk
			  # xdg-desktop-portal-cosmic
			  # xdg-desktop-portal-gnome
			  # xdg-desktop-portal-luminous
			  # xdg-desktop-portal-phosh
			  # xdg-desktop-portal-termfilechooser
			  # xdg-desktop-portal-xapp
	      # xdg-desktop-portal-wlr
	      # xdg-desktop-portal-hyprland
	    ];
			config = {
			  common = {
			    default = ["gtk"];
			  };
			};
		};
}
