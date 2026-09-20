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


  cfg        = config.racooonfig;
  agents     = import ./agent.nix;
  editor     = import ./editor.nix;
  keymap     = import ./keymap.nix;
  workspace  = import ./workspace.nix;
  jsonc      = inputs.racooonfig.jsonc;
  mapFile    = inputs.racooonfig.mapFile;
  appearance = jsonc.readFile ./preferences/appearance.json;
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
        userSettings = lib.mkMerge [
          agents.aichat
          editor
          keymap
          workspace
          appearance
        ];
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
