{ pkgs, ... }:

let
  riceSelector = pkgs.writeShellApplication {
    name = "RiceSelector";
    runtimeInputs = with pkgs; [ rofi coreutils findutils webp-pixbuf-loader ];
    
    text = ''
      bspwm_dir="$HOME/.config/bspwm"
      read -r current_rice < "$bspwm_dir"/.rice

      # List rices
      rices=$(find "$bspwm_dir/rices/" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

      # Find current rice
      selected_index=-1
      index=0
      IFS='
      '
      for rice in $rices; do
        [ "$rice" = "$current_rice" ] && { selected_index=$index; break; }
        index=$((index + 1))
      done
      unset IFS

      # Show the rofi selection menu.
      selected=$(
        IFS='
        '
        for rice in $rices; do
          printf "%s\000icon\037%s/rices/%s/preview.webp\n" "$rice" "$bspwm_dir" "$rice"
        done | rofi -dmenu -p "RiceSelector" \
              -theme "$HOME/.config/rofi/themes/RiceSelector.rasi" \
              -selected-row "$selected_index"
      )

      # If a valid option was selected, write the value to the configuration file and change theme.
      if [ -n "$selected" ] && [ "$selected" != "$current_rice" ]; then
        echo "$selected" > "$bspwm_dir"/.rice
        "$bspwm_dir"/bin/GenerateTheme
      fi
    '';
  };
in
{
  home.packages = with pkgs; [
    riceSelector

    libwebp
    gdk-pixbuf
    gdk-pixbuf-xlib
    webp-pixbuf-loader
  ];
}
