{ ... }:
{

  security.pam.services.i3lock.enable = true;
  security.pam.services.i3lock = { };
  security.pam.services.i3lock.text = ''
    		auth include login
    	'';
  services = {
    ###################################
    ## THUNAR OPTIMALIZATION
    #####################################
    tumbler.enable = true; # thumbnails di Thunar
    udisks2.enable = true; # Storage Manager (USBmounting, external HDD/SSD)
    dbus.enable = true; # App to App Communications (Discord RPC, MountUSB in FileManager)
    gvfs.enable = true; # Thunar integration with plugins
  };
}
