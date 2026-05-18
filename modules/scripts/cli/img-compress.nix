{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "compress-images";
      runtimeInputs = [
        pkgs.imagemagick
        pkgs.jpegoptim
        pkgs.oxipng
        pkgs.pngquant
      ];

      text = ''
      #!/usr/bin/env bash
      # ==============================
      #  Image Compressor Script (Nix Edition)
      #  Supports: lossless & lossy
      #  Author: ChatGPT (for tquilla 😎)
      # ==============================

      # cara menggunakannya :
      # | script + path/to/images + Mode (losless/lossy)
      # contoh :
      # ./compress-images.sh ~/Pictures lossless

      set -euo pipefail

      if [ $# -lt 2 ]; then
        echo "Usage   : compress-images <folder> <mode>"
        echo "Mode    : lossless | (normal kompresi tanpa penurunan kualitas)"
        echo "          lossy    : (maksimum kompresi dengan sedikit penurunan kualitas)\n"
        echo "example | compress-images ~/Pictures/Wallpaper lossy"
        echo "folder  : ~/Pictures/Wallpaper (example) 
             ├── wallpaper10.png
             ├── wallpaper11.jpg
             ├── wallpaper2.jpg
             ├── wallpaper3.png
             ├── wallpaper4.png
             └── wallpaper5.png\n"
        exit 1
      fi

      DIR="$1"
      MODE="$2"

      shopt -s nullglob

      case "$MODE" in
        lossless)
          echo "🔹 Mode: LOSSLESS (tanpa kehilangan kualitas)"
          for img in "$DIR"/*.{png,jpg,jpeg,JPG,PNG,JPEG}; do
            case "$img" in
              *.png|*.PNG)
                echo "Compressing (PNG): $img"
                oxipng -o6 --strip safe "$img"
                ;;
              *.jpg|*.jpeg|*.JPG|*.JPEG)
                echo "Compressing (JPEG): $img"
                jpegoptim --strip-all "$img"
                ;;
            esac
          done
          ;;
  
        lossy)
          echo "🔹 Mode: LOSSY (kompresi dengan sedikit penurunan kualitas)"
          mkdir -p "$DIR/compressed"
          for img in "$DIR"/*.{png,jpg,jpeg,JPG,PNG,JPEG}; do
            base=''$(basename "$img")
            out="$DIR/compressed/$base"
            case "$img" in
              *.png|*.PNG)
                echo "Compressing (PNG): $img"
                pngquant --quality=70-90 --output "$out" --force "$img"
                ;;
              *.jpg|*.jpeg|*.JPG|*.JPEG)
                echo "Compressing (JPEG): $img"
                convert "$img" -sampling-factor 4:2:0 -strip -quality 85 "$out"
                ;;
            esac
          done
          echo "✅ Hasil tersimpan di: $DIR/compressed/"
          ;;
  
        *)
          echo "Mode tidak dikenali. Gunakan: lossless atau lossy"
          exit 1
          ;;
      esac

      echo "🎉 Selesai!"
      '';
      checkPhase = "";
    })
  ];
}
