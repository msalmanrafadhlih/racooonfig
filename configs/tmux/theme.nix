{ ... }:

{
  programs.tmux.extraConfig = ''
    set -g message-style fg=black,bg=magenta,bold
    set -g pane-border-style fg='magenta'
    set -g pane-active-border-style fg='green'
    set -g mode-style fg='black',bg='blue'

    set -g status-position top
    set -g status-style fg='black',bg='default'

    set -g status-left-length 60
    set -g status-left ""

    set -g status-right-length 120
    set -g status-right '#[fg=magenta]#[fg=default,bg=magenta] #[fg=white,bg=black] #S #[fg=magenta]#[fg=default,bg=magenta] #[fg=white,bg=black] #{p:pane_current_path} '
    # set -g status-right '#[fg=magenta]#[fg=default,bg=magenta] #[fg=white,bg=black] #W #[fg=magenta]#[fg=default,bg=magenta] #[fg=white,bg=black] #{p:pane_current_path} #[fg=green]#[fg=default,bg=green] #[fg=white,bg=black] #S '

    set -g window-status-separator "#[bg=default] "
    set -g window-status-current-format "#[fg=white,bg=black] #W #[fg=black,bg=blue] #I#[fg=blue,bg=default]"
    set -g window-status-format "#[fg=white,bg=black] #W #[fg=black,bg=yellow] #I#[fg=yellow,bg=default]"
  '';
}
