# ./aliases.nix
{
  tquilla = "colorscript -r";
  NIXOS = "cd ~/.dotfiles/system && ls";
  HOME = "cd ~/.dotfiles/$XDG_CURRENT_DESKTOP && ls";

  GRAPH = "git log --oneline --decorate --graph --all";
  GIT = "git add . && git commit -m";

  RUNNING = "systemctl --user list-units --state=running";
  SYSRUNNING = "systemctl list-units --state=running";
  USAGELOG = "sudo journalctl --disk-usage";
  SYSTEMD = "systemctl list-unit-files --type=service";
  SYSAPPS = "thunar /run/current-system/sw/share/applications";
  TV = "nix run nixpkgs#television";

  ## SYSTEM CONFIGURATIONS
  USER = "hx ~/.dotfiles/system/modules/users.nix";
  ALIAS = "hx ~/.dotfiles/system/modules/aliases.nix";
  SYSINSTALL = "hx ~/.dotfiles/system/modules/system-packages.nix";
  NIX = "hx ~/.dotfiles/system/modules/configuration.nix";
  HNIX = "bat ~/.dotfiles/system/modules/hardware-configuration.nix";
  FLAKE = "hx ~/.dotfiles/system/flake.nix";
  LOCK = "bat ~/.dotfiles/system/flake.lock";
  SYSMDL = "yazi ~/.dotfiles/system/modules";

  ## USER CONFIGURATIONS {EDIT}
  DOTS = "yazi ~/.dotfiles/$XDG_CURRENT_DESKTOP/home";
  INSTALL = "hx ~/.dotfiles/$XDG_CURRENT_DESKTOP/modules/packages.nix";
  HOMEFLAKE = "cd ~/.dotfiles/$XDG_CURRENT_DESKTOP && ls && hx ~/.dotfiles/$XDG_CURRENT_DESKTOP/flake.nix";
  MDL = "yazi ~/.dotfiles/$XDG_CURRENT_DESKTOP/modules";

  ## USER CONFIGURATIONS {SAVE}
  BIN = "chmod +x ~/.local/bin/*.sh";

  ## Xutils
  CLASS = "xprop | grep CLASS";
  NAME = "xprop | grep NAME";
  WMINFO = "nix-shell -p xwininfo --run xwininfo";

  ## LINK BOOKMARKS
  PERSONAL = "hx ~/.config/bookmarks/personal.txt";
  WORK = "hx ~/.config/bookmarks/work.txt";

  ## DOTSFILE CONNFIGURATION
  # ... ads your config raws here

  ## Suckless Stuff
  SUCKPULL = "mv config.h config.h.bak && git pull";
  NSHELL = "cd shell && nix-shell && cd ..";
  PATCH = "patch -p1 <";
  STCONF = "cd ~/.config/st && hx config.h";
  DMENUCONF = "cd ~/.config/dmenu && hx config.h";
  DWMCONF = "cd ~/.config/dwm && hx config.h";
  CONFSAVE = "mv config.h config.h.bak";
  CONFDEL = "cp config.h.bak config.h";
  MAKE = "make clean && make && make install PREFIX=$HOME/.local";
  SUCKLESS = "hx ~/.dotfiles/system/system/modules/suckless.nix";

  ## Tmux
  TMUXSAVE = "tmux source-file ~/.config/tmux/tmux.conf";
  TMUXDEL = "tmux kill-server";
  MOSH = "mosh --ssh='ssh -p 8022'";

  # Python
  py = "python3";
  PY-SERVER = "python3 -m http.server";

  ##  OTHER
  BASHSAVE = "source ~/.bashrc && dunstify 'BASHRC saved'";
  ZSHSAVE = "source ~/.zshrc && dunstify 'ZSHRC saved'";

  OLD = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
  GBGOLD = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3";
  GBG = "sudo nix-collect-garbage";
  OPTIMISE = "sudo nix-store --optimise";
  GC = "sudo nix-store --gc";
  REPAIR = "sudo nix-store --verify --check-contents --repair";
  CLEAR = "clear";
  clar = "clear";
  CLS = "clear";
  cls = "clear";
  C = "clear";
  c = "clear";

  PKG = "nix search nixpkgs";
  SRC = "fc-list | grep -i";
  FONTLIST = "fc-match -s";
  SVFONT = "fc-cache -fv";
  GETHASH = "nix store prefetch-file"; ## GETHASH <link>
  PKGLIST = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq";
  CONNECT = "sudo tailscale up --operator=$USER";

  ## Utilities
  CAM = "~/.local/bin/opencam";
  IMGCOMPRESS = "~/.local/bin/compress-images.sh";
  DTAR = "~/.local/bin/tar.sh"; ## overwite folder to folder.tar.gz
  XYZ = "~/.local/bin/xyz.sh";
  MPG = "ffmpeg -i"; ## MPG <path/to/img.png> <overwrite/img/file-extension>
  AISTUDIO = "cd ~/.config/aistudio";
  yz = "yazi";
  YZ = "yazi";

  ## POWER
  REBOOT = "sudo reboot";
  OFF = "poweroff";
}
