{
  pkgs,
  config,
  lib,
  ...
}:

let
  ezMagick = pkgs.writeShellApplication {
    name = "ez-magick";

    runtimeInputs = [
      pkgs.imagemagick
      pkgs.findutils
    ];

    text = ''
      set -euo pipefail

      usage() {
        cat <<EOF
      🎨 ez-magick - Simplified ImageMagick Wrapper

      Usage:
        ez-magick <command> [options]

      Commands:
        convert <input> <format>
        resize <size> <in> <out>
        compress <quality> <in> <out>
        crop <geometry> <in> <out>
        blur <amount> <in> <out>
        gray <in> <out>
        tint <hex> <in> <out>
        palette <in>
        border <color> <size> <in> <out>
        stitch <in1> <in2> <out>
        watermark <text> <in> <out>
        info <in>

      Examples:
        ez-magick convert image.png webp
        ez-magick resize 1920x1080 in.jpg out.jpg
      EOF
      }

      [[ $# -eq 0 ]] && {
        usage
        exit 1
      }

      COMMAND="$1"
      shift

      case "$COMMAND" in
        convert)
          if [[ $# -ne 2 ]]; then
            echo "Error: ez-magick convert <input> <format>"
            exit 1
          fi

          INPUT="$1"
          FORMAT="$2"

          convert_one() {
            local img="$1"
            local dir
            dir="$(dirname "$img")"

            local filename
            filename="$(basename "''${img%.*}")"

            mkdir -p "$dir/converted"
            local out="$dir/converted/$filename.$FORMAT"

            if [[ "$FORMAT" == "avif" || "$FORMAT" == "heic" ]]; then
              magick "$img" \
                -define heic:lossless=true \
                "$out"
            else
              magick "$img" "$out"
            fi

            echo "✅ Converted: $out"
          }

          if [[ -f "$INPUT" ]]; then
            convert_one "$INPUT"
          elif [[ -d "$INPUT" ]]; then
            find "$INPUT" -maxdepth 1 -type f | while read -r img; do
              convert_one "$img"
            done
          else
            echo "❌ Path tidak valid: $INPUT"
            exit 1
          fi
          ;;

        resize)
          [[ $# -ne 3 ]] && {
            echo "Error: ez-magick resize <size> <in> <out>"
            exit 1
          }
          magick "$2" -resize "$1" "$3"
          echo "✅ Resize selesai: $3"
          ;;

        compress)
          [[ $# -ne 3 ]] && {
            echo "Error: ez-magick compress <quality> <in> <out>"
            exit 1
          }
          magick "$2" -quality "$1" "$3"
          echo "✅ Compress selesai: $3"
          ;;

        crop)
          [[ $# -ne 3 ]] && {
            echo "Error: ez-magick crop <geometry> <in> <out>"
            exit 1
          }
          magick "$2" -crop "$1" +repage "$3"
          echo "✅ Crop selesai: $3"
          ;;

        blur)
          [[ $# -ne 3 ]] && {
            echo "Error: ez-magick blur <amount> <in> <out>"
            exit 1
          }
          magick "$2" -blur "$1" "$3"
          echo "✅ Blur selesai: $3"
          ;;

        gray)
          [[ $# -ne 2 ]] && {
            echo "Error: ez-magick gray <in> <out>"
            exit 1
          }
          magick "$1" -colorspace Gray "$2"
          echo "✅ Grayscale selesai: $2"
          ;;

        tint)
          [[ $# -ne 3 ]] && {
            echo "Error: ez-magick tint <hex> <in> <out>"
            exit 1
          }
          magick "$2" \
            -colorspace gray \
            -fill "$1" \
            -tint 100 \
            "$3"
          echo "✅ Tint selesai: $3"
          ;;

        palette)
          [[ $# -ne 1 ]] && {
            echo "Error: ez-magick palette <in>"
            exit 1
          }
          echo "🎨 Dominant colors:"
          magick "$1" \
            -resize 50x50 \
            -colors 5 \
            -unique-colors txt: |
            grep -E -o '#[0-9A-Fa-f]{6}' |
            sort -u
          ;;

        border)
          [[ $# -ne 4 ]] && {
            echo "Error: ez-magick border <color> <size> <in> <out>"
            exit 1
          }
          magick "$3" \
            -bordercolor "$1" \
            -border "$2" \
            "$4"
          echo "✅ Border selesai: $4"
          ;;

        stitch)
          [[ $# -ne 3 ]] && {
            echo "Error: ez-magick stitch <in1> <in2> <out>"
            exit 1
          }
          magick "$1" "$2" +append "$3"
          echo "✅ Stitch selesai: $3"
          ;;

        watermark)
          [[ $# -ne 3 ]] && {
            echo "Error: ez-magick watermark <text> <in> <out>"
            exit 1
          }
          magick "$2" \
            -gravity center \
            -pointsize 48 \
            -fill "rgba(255,255,255,0.5)" \
            -annotate +0+0 "$1" \
            "$3"
          echo "✅ Watermark selesai: $3"
          ;;

        info)
          [[ $# -ne 1 ]] && {
            echo "Error: ez-magick info <in>"
            exit 1
          }
          identify -verbose "$1" |
            grep -E "Format:|Geometry:|Colorspace:|Filesize:"
          ;;

        *)
          echo "❌ Unknown command: $COMMAND"
          usage
          exit 1
          ;;
      esac
    '';
  };

in
{
  config = lib.mkIf config.racooonfig.homeManager {
    home.packages = [ ezMagick ];
  };
}
