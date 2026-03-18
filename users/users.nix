{ username, lib, pkgs, ... }:

{
  home.username = lib.mkDefault username;
  home.homeDirectory = "/home/${username}";
  programs.git.enable = true;


  # Then use with `nixos-rebuild switch --specialisation gamemode`
  specialisation.gamemode.configuration = {
  # Well, My laptop sekarang kentang! dan butuh minimal usage.
  # Execute this cmd jika perangkat kalian support gaming
  # or adds your gaming configurations here 'its up to you..'

    programs.mangohud = {
      enable = true;
      enableSessionWide = true; 
      settings = {
        fps_limit = 144;
        cpu_temp = true;
        gpu_temp = true;
        ram = true;
        fps = true;
        frame_timing = 1;
      };
    };

    # # to use gamemode with steam edit launch options inside
    # # game -> general -> launch options -> `gamemoderun %command%`
    environment.systemPackages = with pkgs; [
      steam
      gamode
      lutris
      heroic
      steam-run
      winboat
    ];

  };
}
