# ./modules/programs.nix
# programs & system packages
{ pkgs, system, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # services.protonmail-bridge.enable = true;

  programs = {
    # firefox.enable = true;
    xytz.enable = true;
    thunderbird.enable = true;
    st-flexipatch.enable = true;

    # # Enable Nix-ld for dynamic linking (running elf binaries)
    nix-ld.enable = true;
    git.enable = true;
    # steam.enable = true;
    # # to use gamemode with steam edit launch options inside
    # # game -> general -> launch options -> `gamemoderun %command%`
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.rip.packages.${pkgs.stdenv.hostPlatform.system}.default 

    # ======= CLI TOOLS
    gh # Github-Cli
    ripgrep
    git-lfs
    bat
    acpi # Show Battery Information
    yazi
    dust
    fd
    file
    fzf
    procs
    sd
    tokei
    yt-dlp
    btop
    tree
    tmux

    # ======= UTILS
    nixpkgs-fmt
		cachix

    # ======= NETWORKING
    curl
    psmisc # Port kill
    dnsutils # dig
    inetutils
    iputils # ping
    miniserve
    nettools
    nmap
    rsync
    wget

    # ======= REMOTE ACCESS
    freerdp

    # ======= ARCHIVES
    gnutar
    p7zip
    unzip
    xz
    zip

    # ======= COMPILER
    luajit
    python3
      
    # ======= LSP
    # python313Packages.python-lsp-server # (or ty/ruff) python
    # typescript-language-server # javascript, typescript..
    # jdt-language-server # Java
    # vscode-json-languageserver # json
    # vscode-css-languageserver # css
    # superhtml # html
    # rust-analyzer # Rust
    # marksman # .md/markdown
    nixd # nix language
    # taplo # toml
    # yaml-language-server # yaml

  ];
}
