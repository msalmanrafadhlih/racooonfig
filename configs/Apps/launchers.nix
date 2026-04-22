# ./modules/launchers.nix

let
  apps = [
    "discord"
    "org.pulseaudio.pavucontrol"
    "picom"
    "rmpc"
    "rofi"
    "rofi-theme-selector"
    "spotify"
    "st"
    "thunar"
    "thunar-bulk-rename"
    "thunar-settings"
    "vesktop"
    "discord"
    "vivaldi-stable"
    "ChatGPT"
    "Gemini"
    "Claude"
    "chromium-browser"
  ];

  appMappings =
    builtins.listToAttrs (map (name: {
      name = ".local/share/applications/${name}.desktop";
      value = "./Apps/Desktops/${name}.desktop";
    }) apps);
in
{
  # ".icons"                = "Assets/cursors";
  ".config/Assets/Icons"  = "Assets/Icons";
  ".config/Assets/Sounds" = "Assets/Sounds";
  ".config/zsh/.nomedia"  = "zsh/zcompdump";
  ".local/share/asciiart" = "Assets/asciiart";

  "Pictures/Wallpaper"    = "Assets/Wallpaper";
} // appMappings
