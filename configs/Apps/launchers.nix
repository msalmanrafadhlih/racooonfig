# ./modules/launchers.nix

let
  apps = [
    "discord"
    "rmpc"
    "rofi"
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
  ".config/Assets/Icons"    = "./Assets/Icons";
  ".config/Assets/Sounds"   = "./Assets/Sounds";
  ".config/zsh/.nomedia"    = "./zsh/zcompdump";
  ".config/Assets/asciiart" = "./Assets/asciiart";
} // appMappings
