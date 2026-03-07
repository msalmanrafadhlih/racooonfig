{ username, ... }:

{
  # 1. Firewall Modern & Perbaikan Routing (WAJIB untuk NixOS)
  networking.nftables.enable = true;
  networking.firewall = {
    checkReversePath = "loose"; # Mencegah paket Tailscale diblokir sistem

    interfaces."tailscale0" = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPortRanges = [
        { from = 60000; to = 60010; } # Mosh port (10 port cukup untuk personal)
      ];
    };
  };

  # 2. Tailscale Tanpa Flag SSH (Gunakan OpenSSH saja)
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # 3. OpenSSH yang Solid & Hemat RAM
  services.openssh = {
    enable = true;
    openFirewall = false; # Hanya lewat interface tailscale0 di atas
    startWhenNeeded = true; 

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      AllowUsers = [ username ];
      X11Forwarding = false;

      # Menjaga koneksi tetap hidup & membersihkan sesi mati
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
    };
  };

  # 4. Mosh untuk koneksi yang lebih stabil di jalan
  programs.mosh = {
    enable = true;
    openFirewall = false;
  };

	users.users.${username}.openssh.authorizedKeys.keyFiles = [
	  (builtins.fetchurl {
	    url = "https://github.com/msalmanrafadhlih.keys";
	    sha256 = "sha256:04zwfrg4kdb2knw25qxhjdmd9vd3bikpy4qg822g94nfbklpp8k5";
	  })
	];
}
