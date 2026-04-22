{ pkgs, ... }:

let
  get-github-hash = pkgs.writeShellApplication {
    name = "get-github-hash";
    runtimeInputs = [ pkgs.nix ]; 
    
    text = ''
      read -r -p "Input Owner: " owner
      read -r -p "Name Repo: " repo
      read -r -p "Input Rev (Commit/Tag/Branch): " rev
      
      # Ubah instruksi menjadi menggunakan koma
      read -r -p "Input SparseCheckout (pisahkan dgn KOMA, misal: .github, src, README.md): " sparse

      if [[ -z "$owner" || -z "$repo" || -z "$rev" ]]; then
        echo "Error: Owner, Repo, dan Rev wajib diisi!"
        exit 1
      fi

      sparse_line=""
      if [[ -n "$sparse" ]]; then
        formatted_sparse=""
        
        # Mengubah pemisah (IFS) menjadi koma untuk membaca input
        IFS=',' read -ra FOLDERS <<< "$sparse"
        for p in "''${FOLDERS[@]}"; do
          clean_name=$(echo "$p" | xargs)
          
          # Jika tidak kosong, tambahkan ke format Nix
          if [[ -n "$clean_name" ]]; then
            formatted_sparse="$formatted_sparse\"$clean_name\" "
          fi
        done
        sparse_line="sparseCheckout = [ $formatted_sparse ];"
      fi

      tmp_file=$(mktemp --suffix=.nix)
      cat <<EOF > "$tmp_file"
      let pkgs = import <nixpkgs> {};
      in pkgs.fetchFromGitHub {
        owner = "$owner";
        repo = "$repo";
        rev = "$rev";
        $sparse_line
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      }
      EOF

      echo "Memproses hash (Nix sedang mengunduh repo dan menghitung hash)..."
      
      output=$(nix-build "$tmp_file" --no-out-link 2>&1 || true)
      
      # Ekstrak hash dari output
      hash=$(echo "$output" | awk '/got:/ {print $2}')

      if [[ -n "$hash" ]]; then
        echo -e "\n=== HASH BERHASIL DIDAPATKAN ==="
        echo "$hash"
      else
        echo -e "\n=== GAGAL MENGAMBIL HASH ==="
        echo "Cek detail output di bawah ini:"
        echo "$output"
      fi

      rm -f "$tmp_file"
    '';
  };
in
{
  environment.systemPackages = [ get-github-hash ];
}
