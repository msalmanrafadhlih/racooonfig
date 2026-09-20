# Bash/shell. Setting yang sama persis dengan lsp.bash-language-server punya Zed
# (LSP-nya identik: bash-language-server).
{ lib, pkgs, ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "bashIde.globPattern" = "**/*@(.sh|.inc|.bash|.command|.zsh)";
    "bashIde.shellcheckPath" = lib.getExe pkgs.shellcheck;
    "shellcheck.executablePath" = lib.getExe pkgs.shellcheck;

    "[shellscript]" = {
      "editor.tabSize" = 2;
    };
  };
}
