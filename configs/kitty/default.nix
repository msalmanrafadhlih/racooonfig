{
  pkgs,
  lib,
  mkSymlink,
  config,
  ...
}:
let
  cfg = config.racooonfig;
  configs = {
    "kitty/themes" = "themes";
  };
in
{

  config = lib.mkIf (cfg.homeManager && builtins.elem "kitty" cfg.listConfigurations) {

    xdg.configFile = mkSymlink {
      target = "kitty";
    } configs;

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/terminal" = [ "kitty.desktop" ];
    };

    home.packages = with pkgs; [
      # Perbaikan modul nerd-fonts untuk NixOS rilis terbaru (24.11+ / unstable)
      nerd-fonts.jetbrains-mono
      nerd-fonts.victor-mono
    ];

    programs.kitty = {
      enable = true;

      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
        mode = "no-title no-cwd";
      };

      extraConfig = lib.mkIf builtins.elem "bspwm" cfg.listConfigurations ''
        include themes/racooonfig.conf
      '';

      settings = {
        # Fonts & Opacity
        bold_font = "JetBrainsMono NF";
        italic_font = "VictorMono Nerd Font";
        bold_italic_font = "VictorMono Nerd Font";
        font_size = "9.0";

        background_opacity = lib.mkForce "0.5";
        background_blur = 1;
        placement_strategy = "center";
        confirm_os_window_close = 0;
        tab_bar_style = "powerline";
        window_padding_width = "10";
        window_border_width = "3pt";
        inactive_text_alpha = "0.7";

        # OPTIMASI MEMORI RAM
        scrollback_lines = 500; # Menghemat penggunaan buffer RAM
        scrollback_pager_history_size = 0;

        # OPTIMASI CPU & GRAFIS
        repaint_delay = 30;     # Menurunkan FPS agar menghemat daya CPU
        input_delay = 10;
        sync_to_monitor = true;

        # MENONAKTIFKAN ANIMASI YANG MEMAKAN RESOURCE
        cursor_trail = 0;       # Mematikan jejak kursor (Sangat hemat resource GPU)
        cursor_blink_interval = 0; # Kursor statis mencegah background render loop
        enable_audio_bell = false;
        window_alert_on_bell = false;
        bell_on_tab = " ";

        # PERBAIKAN TIPE DATA (Menggunakan Boolean asli, bukan String)
        x11_hide_window_decorations = true;
        hide_window_decorations = true;
        draw_minimal_borders = true;
        remember_window_size = false;
        allow_remote_control = false; # Set false jika kontrol eksternal tidak digunakan
        # listen_on = "unix:/tmp/kitty";

        # Pengaturan Mouse & Seleksi teks
        mouse_hide_wait = 1;
        select_by_word_characters = "@-./_~?&=%+#a";
        copy_on_select = true;

        cursor_shape = "block";
        cursor_shape_unfocused = "beam";
        cursor_beam_thickness = 1.5;
        cursor_stop_blinking_after = 15.0;
      };
    };
  };
}
