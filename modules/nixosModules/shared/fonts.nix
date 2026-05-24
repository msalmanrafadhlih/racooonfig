{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf cfg.enable  {
    fonts = {
      enableDefaultPackages = lib.mkDefault true;

      fontconfig = {
        enable = lib.mkDefault true;

        # Rendering settings
        antialias = lib.mkDefault true;
        hinting.enable = lib.mkDefault true;
        hinting.style = lib.mkDefault "slight"; # "slight" biasanya lebih mulus daripada "full" di layar modern
        subpixel.rgba = lib.mkDefault "rgb";

        defaultFonts = {
          # Prioritas Font Coding (Terminal & Editor)
          monospace = lib.mkOptionDefault [
            "JetBrainsMono Nerd Font"
            "FiraCode Nerd Font" # Cadangan kalau JetBrains gagal load
            "Noto Sans Mono"
          ];

          # Prioritas Font UI (Browser, Menu, Desktop)
          sansSerif = lib.mkOptionDefault [
            "Roboto" # Font UI yang bersih & modern
            "Noto Sans" # Fallback standar Google
            "DejaVu Sans"
          ];

          # Prioritas Font Dokumen
          serif = lib.mkOptionDefault [
            "Noto Serif"
            "DejaVu Serif"
          ];

          # Prioritas Emoji (Penting agar emoji berwarna muncul di terminal)
          emoji = lib.mkOptionDefault [
            "Noto Color Emoji"
          ];
        };
      };

      packages = with pkgs; [
        # --- Core Fonts (Wajib ada untuk web/dokumen) ---
        noto-fonts
        noto-fonts-cjk-sans # Penting untuk karakter Asia (China/Jepang/Korea)
        noto-fonts-color-emoji
        liberation_ttf
        dejavu_fonts

        # --- UI Fonts ---
        material-design-icons
        roboto
        cantarell-fonts
        rubik

        # --- Coding Fonts (Pilih 1-2 favorit saja) ---
        # Menghemat space dibanding install semua
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code

        # Opsi: Symbols only (berguna kalau font utama kamu bukan Nerd Font)
        nerd-fonts.symbols-only
      ];
    };
  };
}
