# Format data, config, dan dokumen: JSON, TOML, Markdown, Makefile, SQL, XML.
{ ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "[json]" = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
    };
    "[jsonc]" = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
    };
    "[toml]" = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "tamasfe.even-better-toml"; # taplo
    };
    "[markdown]" = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.wordWrap" = "on";
    };
    "[makefile]" = {
      "editor.insertSpaces" = false; # WAJIB hard tab
    };
    "[sql]" = {
      "editor.tabSize" = 2;
    };
    "[xml]" = {
      "editor.tabSize" = 2;
    };
  };
}
