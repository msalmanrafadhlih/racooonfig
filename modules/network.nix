{ hostname, ... }:


{
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	# services.mullvad-vpn.enable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  #systemd.services = {
  #  NetworkManager-wait-online.enable = true;
  #};

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 3000 5173 8000 8080 ];
      allowedUDPPorts = [ ];
    };
  };
}
