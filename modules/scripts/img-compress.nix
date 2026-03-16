{
  home.file.".local/bin/compress-images.sh" = {
	text = ''
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p imagemagick jpegoptim oxipng pngquant
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
  echo "Usage: $0 <folder> <mode>"
  echo "Mode: lossless | lossy"
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
	executable = true;
  };
}
