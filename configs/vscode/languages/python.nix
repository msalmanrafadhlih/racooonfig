# Python: Pylance (type checking) + Ruff (lint & format).
#
# Ruff sengaja TIDAK di-pin ke path Nix store di sini (beda dari
# nixd/shellcheck/rust-analyzer) — biar konsisten sama pilihan Zed yang pakai
# "ruff" polos dari PATH/devShell proyek, karena versi ruff biasanya ikut
# per-proyek (lewat direnv), bukan dependency global. Rule lint
# (select/ignore/line-length) taruh di pyproject.toml/ruff.toml proyek, bukan di
# sini — supaya konsisten dipakai baik dari CLI maupun editor mana pun.
{ ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "python.analysis.typeCheckingMode" = "standard";
    "python.analysis.autoImportCompletions" = true;
    "python.analysis.autoSearchPaths" = true;
    "python.analysis.useLibraryCodeForTypes" = true;
    "python.analysis.diagnosticMode" = "workspace";
    "python.analysis.inlayHints.variableTypes" = true;
    "python.analysis.inlayHints.functionReturnTypes" = true;
    "python.analysis.inlayHints.callArgumentNames" = "all";
    "python.analysis.inlayHints.pytestParameters" = true;

    "python.terminal.activateEnvironment" = true; # setara terminal.detect_venv

    "[python]" = {
      "editor.tabSize" = 4;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "charliermarsh.ruff";
      "editor.codeActionsOnSave" = {
        "source.fixAll.ruff" = "explicit";
        "source.organizeImports.ruff" = "explicit";
      };
    };
  };
}
