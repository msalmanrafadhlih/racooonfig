{ username, config, ...}: let
  home = config.home.homeDirectory;
  mountdir = "${home}/mnt/gdrive";
  # root_folder_id = "";
  # client_id = "1009718778774-dt220ti1a4qpoo1p0u91umdhonavfn6h.apps.googleusercontent.com";
in {
  programs.rclone = {
    enable = true;

    remotes = {
      gdrive = {
        config = {
          type = "drive";
          scope = "drive";
          # root_folder_id = root_folder_id;
          # client_id = client_id;
          config_is_local = true;
          disable_http2 = true;
        };

        # # ----- use `rclone config` to login google if secrets is disabled!
        #  secrets = {
        #    client_secret = config.sops.secrets."rclone/client-secret".path;
        #    token = config.sops.secrets."rclone/token".path;
        #  };

        mounts."gdrive" = {
          enable = true;
          mountPoint = mountdir;
          options = {
            allow-non-empty = true;
            allow-other = true;
            buffer-size = "32M";
            cache-dir = "${home}/.cache/rclone";
            vfs-cache-mode = "full"; # off - writes - full
            vfs-read-chunk-size = "128M";
            vfs-read-chunk-size-limit = "1G";
            dir-cache-time = "720h";
            poll-interval = "1m"; 
            vfs-cache-max-age = "1h";
            vfs-cache-max-size = "1G";
            umask = "000";
            gid = "100";
          };
        };
      };
    };
  };

  # sops.secrets = {
  #   "rclone/client-secret" = {};
  #   "rclone/token" = {};
  # };

  systemd.user = {
    startServices = "sd-switch";

    tmpfiles.rules = [
      "d ${mountdir} 0755 ${username} users -"
    ];
  };
}
