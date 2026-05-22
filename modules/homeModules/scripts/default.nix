{ ... }:
{
  imports = [
    ./cli/01chat.nix
    ./cli/wallpaper-selection.nix
    ./cli/img-compress.nix
    ./cli/battery.nix
    ./cli/brightness.nix
    ./cli/bookmarks.nix
    ./cli/get-github-hash.nix
    ./cli/volume.nix
    ./cli/pandoc.nix
    ./cli/image-editor.nix
    ./cli/set-gtk-theme.nix
    
    ./colorscript.nix
    ./opencam.nix
    ./media.nix
    ./tar.nix
    ./github-repos.nix
    ./xyz.nix
    ./run.nix
    ./get-wsize.nix
  ];
}
