{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.racooonfig;
  local = "${config.home.homeDirectory}/.config/mpd";
  home = "${config.home.homeDirectory}";
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "mpd" cfg.listConfigurations) {
    services.mpd = {
      enable = true;

      musicDirectory = "${home}/Music";
      playlistDirectory = "${home}/Music";
      dataDir = "${local}/dataDir";

      # network.listenAddress = "127.0.0.1";
      # network.port = 6600;
      network.listenAddress = "any";
      network.startWhenNeeded = true;

      extraConfig = ''
                follow_outside_symlinks "yes"
                follow_inside_symlinks "yes"
                auto_update "yes"
                log_level "verbose"

                audio_output {
        	        type "pulse"
        	        name "PipeWire Pulse Output"
                }
      '';
    };

    home.packages = with pkgs; [
      playerctl
      mpc
      #		mpdris2
    ];

    #   home.file.".config/mpDris2/mpDris2.conf" = {
    #   	text = ''
    #		[Connection]
    #		host = 127.0.0.1
    #		port = 6600
    #		music_dir = ${home}/Musics/
    #
    #		[Bling]
    #		notify = True
    #		notify_paused = True
    #		mmkeys = True
    #		cdprev = True
    #
    #		[Notify]
    #		urgency = 0
    #		timeout = -1
    #		summary =
    #		body =
    #		paused_summary =
    #		paused_body =
    #   	'';
    #   };
  };

}
