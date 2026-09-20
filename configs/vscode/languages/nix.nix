# Nix: nixd (LSP) + nixfmt, lewat extension jnoortheen.nix-ide.
{ lib, pkgs, ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = lib.getExe pkgs.nixd;
    "nix.formatterPath" = lib.getExe pkgs.nixfmt;

    "[nix]" = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
    };
  };
}
