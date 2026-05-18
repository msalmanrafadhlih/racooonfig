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
        echo "  convert <in> <format>            : Ubah format gambar (contoh: .webp ke .png)"
        echo "  resize <size> <in> <out>         : Ubah ukuran gambar (contoh: 800x600, 50%)"
        echo "  compress <quality> <in> <out>    : Kompresi gambar (1-100, contoh: 80)"
        echo "  crop <geometry> <in> <out>       : Potong gambar (contoh: 800x600+0+0)"
        echo "  blur <amount> <in> <out>         : Efek blur (contoh: 0x8)"
        echo "  gray <in> <out>                  : Ubah ke hitam putih (Grayscale)"
        echo "  tint <hex> <in> <out>            : Warnai gambar dengan kode HEX (contoh: \"#f00e29\")"
        echo "  palette <in>                     : Ekstrak 5 warna dominan (HEX) dari gambar"
        echo "  border <color> <size> <in> <out> : Tambahkan bingkai warna (contoh size: 15x15)"
        echo "  stitch <in1> <in2> <out>         : Gabung dua gambar bersebelahan (horizontal)"
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
            INPUT="''${2:-}"
            FORMAT="''${3:-}"

            if [[ -z "$INPUT" || -z "$FORMAT" ]]; then
                echo "use ez-magick convert [name file or folder] [format] instead! "
                exit 1
            fi

            if [[ -f "$INPUT" ]]; then
                dir="$(dirname "$INPUT")"
                filename="$(basename "''${INPUT%.*}")"
                mkdir -p "$dir/converted"
                magick "$INPUT" \
                    -define heic:lossless=true \
                    "$dir/converted/''${filename}.''${FORMAT}"
                echo "✅ Converted: $INPUT"

            elif [[ -d "$INPUT" ]]; then
                mkdir -p "$INPUT/converted"
                for img in "$INPUT"/*; do
                    [[ -f "$img" ]] || continue
                    filename="$(basename "''${img%.*}")"
                    magick "$img" \
                        -define heic:lossless=true \
                        "$INPUT/converted/''${filename}.''${FORMAT}"
                    echo "✅ Converted: $img"
                done
            else
                echo "Error: path tidak valid"
                exit 1
            fi
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
        tint)
          if [ $# -ne 3 ]; then echo "Error: ez-magick tint <hex> <in> <out>"; exit 1; fi
          # Mengubah ke grayscale dulu agar warna hex teraplikasi merata, lalu di-tint 100%
          magick "$2" -colorspace gray -fill "$1" -tint 100 "$3"
          echo "✅ Berhasil diwarnai dengan $1: $3"
          ;;
        palette)
          if [ $# -ne 1 ]; then echo "Error: ez-magick palette <in>"; exit 1; fi
          echo "🎨 5 Warna dominan dari $1:"
          # Di-resize dulu agar proses kalkulasi warnanya instan, lalu ambil 5 warna
          magick "$1" -resize 50x50 -colors 5 -unique-colors txt: | grep -E -o "#[0-9A-Fa-f]{6}" | sort -u
          ;;
        border)
          if [ $# -ne 4 ]; then echo "Error: ez-magick border <color> <size> <in> <out>"; exit 1; fi
          # Hati-hati dengan tanda kutip pada hex color
          magick "$3" -bordercolor "$1" -border "$2" "$4"
          echo "✅ Berhasil menambahkan bingkai $1 sebesar $2: $4"
          ;;
        stitch)
          if [ $# -ne 3 ]; then echo "Error: ez-magick stitch <in1> <in2> <out>"; exit 1; fi
          # +append menggabungkan secara horizontal. (Ganti ke -append jika ingin vertikal)
          magick "$1" "$2" +append "$3"
          echo "✅ Berhasil menggabungkan gambar: $3"
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
{ environment.systemPackages = [ image-magick ]; }
