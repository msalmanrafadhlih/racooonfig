{ ... }:

{
  programs.tmux.extraConfig = ''
    # Split
    bind | split-window -h -c "#{pane_current_path}"
    bind - split-window -v -c "#{pane_current_path}"
    unbind '"'
    unbind %

    bind x kill-pane

    # Navigation
    unbind l
    unbind k
    bind h select-pane -L
    bind l select-pane -R
    bind k select-pane -U
    bind j select-pane -D

    # Resize
    bind -n C-M-h resize-pane -L
    bind -n C-M-l resize-pane -R
    bind -n C-M-k resize-pane -U
    bind -n C-M-j resize-pane -D
  '';
}
