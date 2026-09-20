# Lua: sumneko.lua (lua-language-server).
{ ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "Lua.runtime.version" = "LuaJIT";
    "Lua.diagnostics.globals" = [
      "vim"
      "hs"
      "awesome"
      "client"
      "screen"
    ];
    "Lua.workspace.checkThirdParty" = false;
    "Lua.hint.enable" = true;
    "Lua.hint.setType" = true;
    "Lua.hint.paramType" = true;
    "Lua.hint.paramName" = "All";
    "Lua.hint.arrayIndex" = "Enable";
    "Lua.completion.enable" = true;
    "Lua.completion.showParams" = true;
    "Lua.completion.callSnippet" = "Replace";

    "[lua]" = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "sumneko.lua";
    };
  };
}
