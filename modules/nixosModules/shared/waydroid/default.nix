{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.racooonfig;

  waydroid-launcher = pkgs.callPackage ./script-waydroid.nix { }; 

  hasWaylandSession =
    lib.any (x: builtins.elem x cfg.desktopManager) [
      "plasma"
      "gnome"
    ]
    || lib.any (x: builtins.elem x cfg.windowManager) [
      "hyprland"
      "niri"
    ];
in
{
  config = lib.mkIf (cfg.enable && hasWaylandSession) {
    virtualisation.waydroid.enable = builtins.elem "waydroid" cfg.gamemode.programs;
    # NixOS yang lebih baru menggunakan nftables sebagai
    # backend firewall. Gunakan varian Waydroid nftables.
    virtualisation.waydroid.package = pkgs.waydroid-nftables;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      waydroid-launcher
    ];

  };
}
