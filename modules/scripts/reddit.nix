{ config, ... }:

let
    HOME = config.home.homeDirectory;
in
{
	home.file.".local/share/applications/reddit.desktop" = {
		text = ''
[Desktop Entry]
StartupWMClass=chromium-browser
Version=1.0
Name=Reddit
GenericName=Reddit 
Comment=reddit 
Exec=${HOME}/.config/polybar/script/reddit.sh
StartupNotify=true
Terminal=false
Icon=${HOME}/Pictures/iconApps/Reddit.png
Type=Application
Categories=Network;WebBrowser;
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/webcal;x-scheme-handler/mailto;x-scheme-handler/about;x-scheme-handler/unknown
Actions=new-window;new-private-window;
Path=
		'';
		executable = true;
	};
}
