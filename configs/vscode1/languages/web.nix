# Web: TypeScript/JavaScript, HTML/CSS, Astro, dan Tailwind CSS.
{ pkgs, ... }:

let
  # Blok "[bahasa]" yang identik untuk semua bahasa yang diformat Prettier.
  prettierBlock = {
    "editor.tabSize" = 2;
    "editor.formatOnSave" = true;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  # Regex Tailwind class-detection — disalin persis dari settings Zed.
  tailwindClassRegex = [
    ''className="([^"]*)"''
    ''className=\{`([^`]*)`\}''
    ''class="([^"]*)"''
    ''class:list=\[([^\]]*)\]''
    ''\bcva\(([^)]*)\)''
    ''\bclsx\(([^)]*)\)''
    ''\bcn\(([^)]*)\)''
    ''\bcx\(([^)]*)\)''
    ''\btv\(([^)]*)\)''
    ''\btwMerge\(([^)]*)\)''
  ];
in

{
  programs.vscode.profiles.default.userSettings = {
    # ── TypeScript / JavaScript ──────────────────────────────────────
    # Satu set setting untuk TS & JS lewat namespace gabungan "js/ts.*".
    # Inlay hints-nya sama seperti punya Zed.
    "js/ts.inlayHints.parameterNames.enabled" = "all";
    "js/ts.inlayHints.parameterNames.suppressWhenArgumentMatchesName" = false;
    "js/ts.inlayHints.parameterTypes.enabled" = true;
    "js/ts.inlayHints.variableTypes.enabled" = true;
    "js/ts.inlayHints.variableTypes.suppressWhenTypeMatchesName" = false;
    "js/ts.inlayHints.propertyDeclarationTypes.enabled" = true;
    "js/ts.inlayHints.functionLikeReturnTypes.enabled" = true;
    "js/ts.inlayHints.enumMemberValues.enabled" = true;

    "js/ts.tsdk.path" = "${pkgs.typescript}/lib/node_modules/typescript/lib";
    "js/ts.suggest.completeFunctionCalls" = true;
    "js/ts.updateImportsOnFileMove.enabled" = "always";
    "js/ts.preferences.includePackageJsonAutoImports" = "auto";
    "js/ts.referencesCodeLens.enabled" = true;
    "js/ts.referencesCodeLens.showOnAllFunctions" = true;
    "js/ts.implementationsCodeLens.enabled" = true;

    # ── Tailwind CSS ─────────────────────────────────────────────────
    # Butuh "editor.quickSuggestions".strings = true (lihat ../editor.nix).
    "tailwindCSS.includeLanguages" = {
      astro = "html";
      javascript = "javascript";
      typescript = "javascript";
      typescriptreact = "html";
      vue = "html";
    };
    "tailwindCSS.classFunctions" = [
      "cva"
      "cx"
      "clsx"
      "cn"
      "twMerge"
      "tv"
      "ctl"
    ];
    "tailwindCSS.experimental.classRegex" = tailwindClassRegex;

    # ── Per-bahasa: tab size, format on save, formatter ──────────────
    "[typescript]" = prettierBlock;
    "[javascript]" = prettierBlock;
    "[typescriptreact]" = prettierBlock;
    "[javascriptreact]" = prettierBlock;
    "[css]" = prettierBlock;
    "[scss]" = prettierBlock;
    "[html]" = prettierBlock;
    "[astro]" = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "astro-build.astro-vscode";
    };
  };
}
