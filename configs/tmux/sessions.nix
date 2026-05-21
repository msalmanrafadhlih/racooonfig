{ ... }:

{
  programs.tmux.extraConfig = ''
    bind-key N command-prompt -p "New session name:" "new-session -s '%%'"
    bind-key K confirm-before -p "Kill session #S? (y/n)" kill-session

    unbind M-k
    bind -n M-j switch-client -p
    bind -n M-k switch-client -n
    bind -n M-o switch-client -l

    bind . command-prompt -I "#S" "rename-session '%%'"
    bind s choose-tree -Zs
  '';
}
