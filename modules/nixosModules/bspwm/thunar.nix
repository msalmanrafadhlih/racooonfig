{ pkgs, lib, ... }: {


  programs = {
		thunar = {
			enable = lib.mkDefault true;
			plugins = with pkgs; [
				thunar-volman
				thunar-dropbox-plugin
				thunar-vcs-plugin
				thunar-media-tags-plugin
				thunar-shares-plugin
				thunar-archive-plugin
			];
		};
  };
}
