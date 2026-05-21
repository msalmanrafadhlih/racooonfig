{ ... }:

{
  programs.tmux.extraConfig = ''
    bind n new-window -c "#{pane_current_path}"
    bind , command-prompt "rename-window %%"

    bind -n M-l next-window
    bind -n M-h previous-window
    bind -n C-] next-window
  '';
}
