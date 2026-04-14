{ username, ... }: let
  home = "/home/${username}";
in
{
  stylix = {
    targets.gtk = {
      enable = false;
      colors = {
        ## Whether to enable & override `config.lib.stylix.colors`
        enable = false;
        ## Attribute sets are recursively merged with `config.lib.stylix.colors`,
        ## while all other non-null types override `config.lib.stylix.colors`.
        # override = null;
      };

      ## Extra code added
      extraCss =''
          @import url("${home}/.config/gtk-3.0/colors.css");
        '';

      ## Whether to enable theming for support for theming Flatpak apps.
      ## Default : config.stylix.autoEnable
      # flatpakSupport.enable = true;

      ## Whether to enable & override config.stylix.fonts.
      fonts = {
        enable = true;
        # override = null;
      };
    };
  };
}
