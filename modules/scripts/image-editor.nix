{ pkgs, ... }:

let
  image-magick = pkgs.writeShellApplication {
    name = "ez-magick";
    runtimeInputs = [ pkgs.imagemagick ];
    text = ''
      usage() {
        echo "🎨 ez-magick - Simplified ImageMagick Wrapper"
        echo "Usage: ez-magick <command> [options] <input> <output>"
        echo ""
        echo "Commands:"
        echo "  convert <in> <out>               : Ubah format gambar (contoh: .webp ke .png)"
        echo "  resize <size> <in> <out>         : Ubah ukuran gambar (contoh: 800x600, 50%)"
        echo "  compress <quality> <in> <out>    : Kompresi gambar (1-100, contoh: 80)"
        echo "  crop <geometry> <in> <out>       : Potong gambar (contoh: 800x600+0+0)"
        echo "  blur <amount> <in> <out>         : Efek blur (contoh: 0x8)"
        echo "  gray <in> <out>                  : Ubah ke hitam putih (Grayscale)"
        echo "  watermark <text> <in> <out>      : Tambahkan teks watermark di tengah"
        echo "  info <in>                        : Lihat detail informasi gambar"
        echo ""
        echo "Examples:"
        echo "  ez-magick resize 1920x1080 input.jpg output.jpg"
        echo "  ez-magick compress 75 foto.png hasil.jpg"
      }

      if [ $# -eq 0 ]; then
        usage
        exit 1
      fi

      COMMAND=$1
      shift

      case "$COMMAND" in
        convert)
          if [ $# -ne 2 ]; then echo "Error: ez-magick convert <in> <out>"; exit 1; fi
          magick "$1" "$2"
          echo "✅ Berhasil dikonversi: $2"
          ;;
        resize)
          if [ $# -ne 3 ]; then echo "Error: ez-magick resize <size> <in> <out>"; exit 1; fi
          magick "$2" -resize "$1" "$3"
          echo "✅ Berhasil di-resize ke $1: $3"
          ;;
        compress)
          if [ $# -ne 3 ]; then echo "Error: ez-magick compress <quality> <in> <out>"; exit 1; fi
          magick "$2" -quality "$1" "$3"
          echo "✅ Berhasil dikompresi (Kualitas $1): $3"
          ;;
        crop)
          if [ $# -ne 3 ]; then echo "Error: ez-magick crop <geometry> <in> <out>"; exit 1; fi
          magick "$2" -crop "$1" +repage "$3"
          echo "✅ Berhasil di-crop ($1): $3"
          ;;
        blur)
          if [ $# -ne 3 ]; then echo "Error: ez-magick blur <amount> <in> <out>"; exit 1; fi
          magick "$2" -blur "$1" "$3"
          echo "✅ Berhasil di-blur ($1): $3"
          ;;
        gray)
          if [ $# -ne 2 ]; then echo "Error: ez-magick gray <in> <out>"; exit 1; fi
          magick "$1" -colorspace Gray "$2"
          echo "✅ Berhasil diubah ke Grayscale: $2"
          ;;
        watermark)
          if [ $# -ne 3 ]; then echo "Error: ez-magick watermark <text> <in> <out>"; exit 1; fi
          magick "$2" -gravity center -pointsize 48 -fill "rgba(255,255,255,0.5)" -annotate +0+0 "$1" "$3"
          echo "✅ Berhasil ditambahkan watermark: $3"
          ;;
        info)
          if [ $# -ne 1 ]; then echo "Error: ez-magick info <in>"; exit 1; fi
          magick identify -verbose "$1" | grep -E "Format:|Geometry:|Colorspace:|Filesize:"
          ;;
        *)
          echo "❌ Perintah tidak dikenali: $COMMAND"
          usage
          exit 1
          ;;
      esac
    '';
  };
in
{ home.packages = [ image-magick ]; }
