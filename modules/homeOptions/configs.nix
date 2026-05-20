# ./default.nix
{ ... }:

{ 
 imports = [
  ../../configs/Apps
  ../../configs/bspwm
  ../../configs/bat
  ../../configs/fastfetch
  ../../configs/zed-editor
  ../../configs/gemini
	../../configs/gtk
	../../configs/qt
  ../../configs/spotify
  ../../configs/kitty
	../../configs/vesktop
	../../configs/com.kdocker
	../../configs/suckless
	../../configs/mpd
	../../configs/nano 
	../../configs/rmpc 
	../../configs/xytz # TUI Youtube downloader and Streaming
	../../configs/matugen
	# ...../configs/rclone
  # ../../configs/zen-browser
  # ../../configs/firefox
  # ../../configs/nwg-drawer # Aplikasi Menu Launcher bergaya drawer
  # ../../configs/zathura # Document Viewer
  # ../../configs/yazelix
  # ../../configs/btm
	# ...../configs/ncmpcpp 
  # ../../configs/inlyne # Markdown Viewer
	# ...../configs/ghostty 
  # ../../configs/alacritty 
  # ../../configs/stylix/targets.nix
 ];
}
