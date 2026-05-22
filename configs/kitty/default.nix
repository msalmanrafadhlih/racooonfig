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

      extraConfig = ''
        include themes/racooonfig.conf
      '';

      settings = {
        # fonts
        bold_font = "JetBrainsMono NF";
        italic_font = "VictorMono Nerd Font";
        bold_italic_font = "VictorMono Nerd Font";
        font_size = "9.0";

        background_opacity = lib.mkForce "0.5";
        placement_strategy = "center";
        confirm_os_window_close = 0;
        tab_bar_style = "powerline";

        window_padding_width = "10";
        window_alert_on_bell = true;
        window_border_width = "3pt";

        inactive_text_alpha = "0.7";

        hide_window_decorations = true;
        draw_minimal_borders = true;
        enable_audio_bell = true;
        bell_on_tab = "🔔 ";
        remember_window_size = false;
        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty";

        mouse_hide_wait = 1;
        select_by_word_characters = "@-./_~?&=%+#a";
        copy_on_select = true;

        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.4";
        cursor_shape = "block";
        cursor_shape_unfocused = "beam";
        cursor_beam_thickness = 1.5;
        cursor_stop_blinking_after = 15.0;
        cursor_blink_interval = 1;
        scrollback_lines = 2000;

      };
    };
  };
}
