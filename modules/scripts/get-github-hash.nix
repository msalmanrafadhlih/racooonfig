{ pkgs, ... }:

let
  get-github-hash = pkgs.writeShellApplication {
    name = "get-github-hash";
    runtimeInputs = [ pkgs.nix-prefetch-github ];
    text = ''
      read -r -p "Masukkan Owner: " owner
      read -r -p "Masukkan Repo: " repo
      read -r -p "Masukkan Rev (Commit/Tag/Branch): " rev

      if [[ -z "$owner" || -z "$repo" || -z "$rev" ]]; then
        echo "Error: Semua input wajib diisi!"
        exit 1
      fi

      echo "Mengambil hash..."
      nix-prefetch-github "$owner" "$repo" --rev "$rev"
    '';
  };
in
{
  home.packages = [ get-github-hash ];
}
