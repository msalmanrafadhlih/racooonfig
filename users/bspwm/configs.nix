# ./default.nix
{ inputs, ... }:

{ 
 imports = [
  ../../configs/Apps
  ../../configs/bspwm
  ../../configs/bat
  ../../configs/fastfetch
  ../../configs/zed-editor
  ../../configs/gemini
  ../../configs/gtk
  ../../configs/spotify
  ../../configs/kitty
  ../../configs/stylix
	../../configs/vesktop
	../../configs/com.kdocker
	../../configs/suckless
	../../configs/mpd
	../../configs/nano 
	../../configs/rmpc 
	../../configs/xytz # TUI Youtube downloader and Streaming
	# ../../configs/rclone
  # ../../configs/zen-browser
  # ../../configs/firefox
  # ../../configs/nwg-drawer # Aplikasi Menu Launcher bergaya drawer
  # ../../configs/zathura # Document Viewer
  # ../../configs/yazelix
  # ../../configs/btm
	# ../../configs/ncmpcpp 
  # ../../configs/inlyne # Markdown Viewer
	# ../../configs/gtk-3.0
	# ../../configs/ghostty 
  # ../../configs/alacritty 

  inputs.stylix.homeModules.stylix
 ];
}
