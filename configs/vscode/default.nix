# vscode.nix
{
  lib,
  pkgs,
  inputs,
  config,
  mkSymlink,
  ...
}:

let
  cfg = config.racooonfig;
  jsonc = inputs.racooonfig.jsonc;
  mapFile = inputs.racooonfig.mapFile;

  agents = import ./agent.nix;
  editor = import ./editor.nix;
  keymap = import ./keymap.nix;
  workspace = import ./workspace.nix;
  appearance = jsonc.readFile ./preferences/appearance.json;

  configs = {
    "Code/User/keybindings.json" = "./preferences/keymaps.json";
    "Code/User/snippets" = "./snippets";
  }
  // lib.optionalAttrs cfg.vscode.mutable {
    "Code/User/settings.json" = "./preferences/settings.json";
  };
in
{
  imports = mapFile ./languages [ ] { };

  config = lib.mkIf (cfg.homeManager && cfg.vscode.enable) {
    home.packages = if cfg.vscode.mutable then [ pkgs.vscode ] else [ ];
    xdg.configFile = mkSymlink { target = "vscode"; } configs;

    programs.vscode = {
      enable = !cfg.vscode.mutable;

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
  };
}
