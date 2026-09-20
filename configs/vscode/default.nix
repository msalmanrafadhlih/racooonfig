{
  lib,
  pkgs,
  inputs,
  config,
  mkSymlink,
  ...
}:

let
  configs = {
    "Code/User/keybindings.json" = "./preferences/keymaps.json";
    "Code/User/snippets" = "./snippets";
  };

  mapFile = inputs.racooonfig.mapFile;
  workspace = import ./workspace.nix;
  editor = import ./editor.nix;
  agents = import ./agent.nix;
  cfg = config.racooonfig;
in

{
  imports = mapFile ./languages [ ] { };

  config = lib.mkIf (cfg.homeManager && builtins.elem "vscode" cfg.listConfigurations) {
    xdg.configFile = mkSymlink {
      target = "vscode";
    } configs;

    programs.vscode = {
      enable = true;

      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = import ./extensions.nix { inherit pkgs; };

        userSettings =
          lib.recursiveUpdate { }
          // (lib.mapAttrs' (k: v: lib.nameValuePair "${k}" v) agents.aichat)
          // (lib.mapAttrs' (k: v: lib.nameValuePair "${k}" v) editor)
          // (lib.mapAttrs' (k: v: lib.nameValuePair "${k}" v) workspace)
          // (builtins.fromJSON (builtins.readFile ./preferences/appearance.json));
      };
    };

    home.packages = [
      pkgs.nixd
      pkgs.nixfmt
      pkgs.shellcheck
      pkgs.rust-analyzer
      pkgs.typescript
      pkgs.github-mcp-server
    ];
  };
}
