{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;

    # plugins = with pkgs.tmuxPlugins; [
    #   # tpm
    # ];

    extraConfig = ''
      # Prefix
      unbind C-b
      set -g prefix C-z
      bind C-z send-prefix

      # Base index start from 1
      set -g base-index 1
      set -g pane-base-index 1

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # performance
      set -s escape-time 0
      set -g history-limit 100000
      setw -g aggressive-resize on
      set -g focus-events on
      set -g display-time 4000

      # RGB support
      set -g default-terminal "tmux-256color"
      set -ga terminal-features ",*:RGB"
      set -ga terminal-features ",*:sixel"

      # Copy mode
      set -g mouse on
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi r send -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -selection clipboard -in"

      # Mouse Clipboard Copy
      unbind -T copy-mode-vi MouseDragEnd1Pane
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "xclip -selection clipboard -in"

      set -g set-clipboard on
      set -g allow-passthrough on
    '';
  };

  imports = [
    ./panes.nix
    ./windows.nix
    ./sessions.nix
    ./theme.nix

    # Pop-ups
    ./display-menu.nix
    ./scripts/tmux-sessions.nix
  ];
}
