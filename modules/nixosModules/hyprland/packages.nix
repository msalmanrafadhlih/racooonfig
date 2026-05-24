{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [

      # ======== X UTILS
      (python3.withPackages (
        ps: with ps; [
          pywal
          haishoku
        ]
      ))

      # ======== GTK
      gtk2
      gtk3
      gtk4
      dconf
      dconf-editor
    ];
  };
}
