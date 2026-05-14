{
  pkgs,
  lib,
  mkSymlink,
  ...
}:
let

  configs = {
    "kitty/themes" = "themes";
  };

in
{

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
      include current-theme.conf
      allow_remote_control yes
    '';

    settings = {
      background_opacity = lib.mkForce "0.5";
      placement_strategy = "center";
      inactive_text_alpha = "0.7";
      confirm_os_window_close = 0;
      tab_bar_style = "powerline";
      font_size = "9.0";

      window_padding_width = "10";
      window_alert_on_bell = false;
      window_border_width = "3pt";

      hide_window_decorations = true;
      draw_minimal_borders = true;
      enable_audio_bell = false;
      bell_on_tab = "🔔 ";
      remember_window_size = false;

      mouse_hide_wait = 1;
      select_by_word_characters = "@-./_~?&=%+#a";
      copy_on_select = true;

      cursor_trail = 1;
      cursor_shape = "block";
      cursor_stop_blinking_after = 0;
      scrollback_lines = 2000;

      bold_font = "JetBrainsMono NF";
      italic_font = "VictorMono Nerd Font";
      bold_italic_font = "VictorMono Nerd Font";
    };
  };
}
