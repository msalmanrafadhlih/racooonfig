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
      # High-performance Lua implementation
      luajit 

      (python3.withPackages (
        ps: with ps; [
          pywal
          haishoku
          websocketd
          websockets
        ]
      ))
    ];
  };
}
