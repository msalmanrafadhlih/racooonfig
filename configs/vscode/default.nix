{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.racooonfig;

  # ── Helper: inlay hints TypeScript/JavaScript yang identik ────────────────
  # Sama seperti punya Zed — dipakai ulang di "typescript.*" & "javascript.*".
  tsInlayHints = {
    "inlayHints.parameterNames.enabled" = "all";
    "inlayHints.parameterNames.suppressWhenArgumentMatchesName" = false;
    "inlayHints.parameterTypes.enabled" = true;
    "inlayHints.variableTypes.enabled" = true;
    "inlayHints.variableTypes.suppressWhenTypeMatchesName" = false;
    "inlayHints.propertyDeclarationTypes.enabled" = true;
    "inlayHints.functionLikeReturnTypes.enabled" = true;
    "inlayHints.enumMemberValues.enabled" = true;
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
  config = lib.mkIf (cfg.homeManager && builtins.elem "vscode" cfg.listConfigurations) {
    programs.vscode = {
      enable = true;

      profiles.default = {
        # Sama seperti mutableUserSettings di Zed: baseline dari Nix, tapi file
        # settings.json tetap boleh diubah langsung dari dalam VSCode di antara
        # `home-manager switch` (di-merge, bukan ditimpa read-only).
        mutableUserSettings = true;

        # Nix yang kelola versi VSCode & daftar extension → matikan pengecekan
        # update bawaan (setara `auto_update = false;` punya Zed).
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        # ════════════════════════════════════════════════════════════════════
        # EXTENSIONS
        # ════════════════════════════════════════════════════════════════════
        extensions = with pkgs.vscode-extensions; [
          # Web Dev — html/css/json/typescript dasar sudah bawaan VSCode
          astro-build.astro-vscode
          bradlc.vscode-tailwindcss
          # Systems
          rust-lang.rust-analyzer
          # Scripting / Data
          ms-python.python
          ms-python.vscode-pylance # ⚠ unfree, lihat catatan allowUnfree di bawah
          charliermarsh.ruff
          sumneko.lua
          # DevOps / Config
          jnoortheen.nix-ide
          mkhl.direnv # setara `load_direnv = "direct"` punya Zed
          mads-hartmann.bash-ide-vscode
          timonwong.shellcheck
          ms-vscode.makefile-tools
          tamasfe.even-better-toml
          ms-azuretools.vscode-docker # handle Dockerfile + docker-compose
          mikestead.dotenv
          skellock.just
          # Data Formats
          redhat.vscode-xml
          # Docs — pengganti "marksman" (belum ada binding marksman resmi di VSCode)
          yzhang.markdown-all-in-one
          # Format — setara `prettier.allowed = true;` punya Zed
          esbenp.prettier-vscode
          # Diagnostics inline — VSCode gak punya ini bawaan seperti Zed
          usernamehw.errorlens
          # Agent / Edit predictions
          github.copilot
          github.copilot-chat
        ];

        # ════════════════════════════════════════════════════════════════════
        # MCP — setara `context_servers` punya Zed
        # ════════════════════════════════════════════════════════════════════
        userMcp.servers = {
          "mcp-server-context7" = {
            type = "http";
            url = "https://mcp.context7.com/mcp";
            # Opsional; isi kalau mau rate limit lebih tinggi.
            headers.CONTEXT7_API_KEY = "";
          };

          "github-mcp-server" = {
            type = "stdio";
            command = lib.getExe pkgs.github-mcp-server;
            args = [ "stdio" ];
            env = {
              # Isi Personal Access Token di sini. Karena file ini biasanya ikut
              # ke-commit ke git, pertimbangkan sops-nix/agenix daripada nulis
              # token asli langsung di sini (sama seperti catatan di config Zed).
              GITHUB_PERSONAL_ACCESS_TOKEN = "";
            };
          };
        };

        # ════════════════════════════════════════════════════════════════════
        # SNIPPETS — file JSON-nya sudah format native VSCode, tinggal pakai
        # ════════════════════════════════════════════════════════════════════
        languageSnippets = {
          rust = builtins.fromJSON (builtins.readFile ./snippets/rust.json);
          typescript = builtins.fromJSON (builtins.readFile ./snippets/typescript.json);
          typescriptreact = builtins.fromJSON (builtins.readFile ./snippets/tsx.json);
          astro = builtins.fromJSON (builtins.readFile ./snippets/astro.json);
        };

        # ════════════════════════════════════════════════════════════════════
        # USER SETTINGS
        # ════════════════════════════════════════════════════════════════════
        userSettings = {
          # ── PERILAKU EDITOR ──────────────────────────────────────────────
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2; # default web dev; override per-bahasa di bawah
          "editor.renderLineHighlight" = "gutter";
          "editor.linkedEditing" = true; # sinkron tag HTML/JSX berpasangan
          "editor.multiCursorModifier" = "ctrlCmd";
          "editor.autoIndent" = "advanced";

          # ── AUTOCOMPLETION ───────────────────────────────────────────────
          "editor.quickSuggestions" = {
            other = true;
            comments = false;
            strings = true; # perlu true supaya IntelliSense Tailwind jalan di className/class
          };
          "editor.parameterHints.enabled" = true;

          # Inlay hints — anotasi tipe inline
          "editor.inlayHints.enabled" = "on";

          # Edit predictions
          "github.copilot.enable" = {
            "*" = true;
          };

          # ── CODE INTELLIGENCE ────────────────────────────────────────────
          "editor.lightbulb.enabled" = "onCode";
          "editor.codeLens" = true;
          "editor.semanticHighlighting.enabled" = true;

          # ── FORMAT & DIAGNOSTICS ─────────────────────────────────────────
          # Global: off — tiap bahasa aktifkan sendiri di blok "[bahasa]" bawah
          "editor.formatOnSave" = false;

          # Error Lens — diagnostic inline (bawaan Zed, extension di VSCode)
          "errorLens.enabledDiagnosticLevels" = [
            "error"
            "warning"
            "info"
          ];

          # ── GIT ───────────────────────────────────────────────────────────
          "git.blame.editorDecoration.enabled" = true;
          "git.blame.statusBarItem.enabled" = true;

          # ── SEARCH ────────────────────────────────────────────────────────
          "search.smartCase" = true;
          "search.useIgnoreFiles" = false; # ikut cari di file yang di-gitignore

          # ── SESSION & STARTUP ────────────────────────────────────────────
          "files.autoSave" = "off";
          "window.confirmBeforeClose" = "always";
          "files.hotExit" = "onExitAndWindowClose"; # setara session.restore_unsaved_buffers
          "security.workspace.trust.enabled" = false; # setara session.trust_all_worktrees
          "window.restoreWindows" = "none"; # jangan auto-reopen window terakhir
          "workbench.startupEditor" = "welcomePage"; # pendekatan terdekat ke "launchpad"

          # ── TERMINAL ──────────────────────────────────────────────────────
          "python.terminal.activateEnvironment" = true; # setara terminal.detect_venv

          # ── AGENT & MCP ───────────────────────────────────────────────────
          "chat.agent.enabled" = true;

          # Auto-approve command tertentu di terminal agent — setara
          # `tool_permissions.tools.terminal.always_allow` punya Zed. Beda
          # sintaks: VSCode pakai string "/regex/": true, bukan {pattern=...}.
          "chat.tools.terminal.enableAutoApprove" = true;
          "chat.tools.terminal.autoApprove" = {
            "/^cargo\\s+(build|check|test|clippy|fmt)\\b/" = true;
            "/^(npm|pnpm|bun)\\s+(install|run|test)\\b/" = true;
          };
          # Catatan: belum ada padanan persis untuk `edit_file.always_deny`
          # (deny-list pola file yang gak boleh diedit agent) — lihat ringkasan
          # di chat untuk opsi terdekat yang tersedia.

          # ── TAILWIND CSS ──────────────────────────────────────────────────
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

          # ── TYPESCRIPT / JAVASCRIPT (vtsls-equivalent: fitur bawaan VSCode) ─
          "typescript.suggest.completeFunctionCalls" = true;
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "typescript.preferences.includePackageJsonAutoImports" = "auto";
          "typescript.referencesCodeLens.enabled" = true;
          "typescript.referencesCodeLens.showOnAllFunctions" = true;
          "typescript.implementationsCodeLens.enabled" = true;
          # Fallback ke TypeScript dari Nix Store; VSCode otomatis pilih versi
          # lokal proyek (node_modules) dulu kalau ada.
          "typescript.tsdk" = "${pkgs.typescript}/lib/node_modules/typescript/lib";

          "javascript.suggest.completeFunctionCalls" = true;
          "javascript.updateImportsOnFileMove.enabled" = "always";
        }
        // (lib.mapAttrs' (k: v: lib.nameValuePair "typescript.${k}" v) tsInlayHints)
        // (lib.mapAttrs' (k: v: lib.nameValuePair "javascript.${k}" v) tsInlayHints)
        // {
          # ── NIX ───────────────────────────────────────────────────────────
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = lib.getExe pkgs.nixd;
          "nix.formatterPath" = lib.getExe pkgs.nixfmt;

          # ── BASH ──────────────────────────────────────────────────────────
          # Setting yang sama persis dengan lsp.bash-language-server punya Zed
          # (LSP-nya identik: bash-language-server).
          "bashIde.globPattern" = "**/*@(.sh|.inc|.bash|.command|.zsh)";
          "bashIde.shellcheckPath" = lib.getExe pkgs.shellcheck;
          "shellcheck.executablePath" = lib.getExe pkgs.shellcheck;

          # ── RUST-ANALYZER ─────────────────────────────────────────────────
          # Sama persis dengan lsp.rust-analyzer punya Zed, cuma diratakan ke
          # gaya key vscode "rust-analyzer.<path>". server.path WAJIB di-pin
          # ke Nix store — extension ini defaultnya download binary sendiri,
          # yang gak akan jalan di NixOS tanpa nix-ld.
          "rust-analyzer.server.path" = lib.getExe pkgs.rust-analyzer;
          "rust-analyzer.check.command" = "clippy";
          "rust-analyzer.cargo.allFeatures" = true;
          "rust-analyzer.cargo.buildScripts.enable" = true;
          "rust-analyzer.procMacro.enable" = true;
          "rust-analyzer.completion.callable.snippets" = "fill_arguments";
          "rust-analyzer.completion.fullFunctionSignatures.enable" = true;
          "rust-analyzer.completion.postfix.enable" = true;
          "rust-analyzer.inlayHints.parameterHints.enable" = true;
          "rust-analyzer.inlayHints.typeHints.enable" = true;
          "rust-analyzer.inlayHints.typeHints.hideClosureInitialization" = false;
          "rust-analyzer.inlayHints.typeHints.hideNamedConstructor" = false;
          "rust-analyzer.inlayHints.chainingHints.enable" = true;
          "rust-analyzer.inlayHints.bindingModeHints.enable" = true;
          "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "with_block";
          "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = "skip_trivial";
          "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;
          "rust-analyzer.inlayHints.discriminantHints.enable" = "fieldless";
          "rust-analyzer.inlayHints.expressionAdjustmentHints.enable" = "reborrow";
          "rust-analyzer.inlayHints.reborrowHints.enable" = "mutable";
          "rust-analyzer.inlayHints.closingBraceHints.enable" = true;
          "rust-analyzer.inlayHints.closingBraceHints.minLines" = 10;
          "rust-analyzer.inlayHints.maxLength" = 30;
          "rust-analyzer.inlayHints.renderColons" = true;
          "rust-analyzer.hover.actions.references.enable" = true;
          "rust-analyzer.hover.actions.run.enable" = true;
          "rust-analyzer.hover.actions.debug.enable" = true;
          "rust-analyzer.lens.enable" = true;
          "rust-analyzer.lens.references.adt.enable" = true;
          "rust-analyzer.lens.references.enumVariant.enable" = true;
          "rust-analyzer.lens.references.method.enable" = true;
          "rust-analyzer.lens.references.trait.enable" = true;

          # ── PYRIGHT (VIA PYLANCE) ────────────────────────────────────────
          "python.analysis.typeCheckingMode" = "standard";
          "python.analysis.autoImportCompletions" = true;
          "python.analysis.autoSearchPaths" = true;
          "python.analysis.useLibraryCodeForTypes" = true;
          "python.analysis.diagnosticMode" = "workspace";
          "python.analysis.inlayHints.variableTypes" = true;
          "python.analysis.inlayHints.functionReturnTypes" = true;
          "python.analysis.inlayHints.callArgumentNames" = true;
          "python.analysis.inlayHints.pytestParameters" = true;
          # Ruff sengaja TIDAK di-pin ke path Nix store di sini (beda dari
          # nixd/shellcheck/rust-analyzer di atas) — biar konsisten sama
          # pilihan Zed yang pakai "ruff" polos dari PATH/devShell proyek,
          # karena versi ruff biasanya ikut per-proyek (lewat direnv), bukan
          # dependency global. Rule lint (select/ignore/line-length) taruh di
          # pyproject.toml/ruff.toml proyek, bukan di sini — supaya konsisten
          # dipakai baik dari CLI maupun editor mana pun.

          # ── LUA ───────────────────────────────────────────────────────────
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

          # ── DOCKER ────────────────────────────────────────────────────────
          # ms-azuretools.vscode-docker sudah nyaman dengan default bawaannya.

          # ════════════════════════════════════════════════════════════════
          # PER-LANGUAGE: tab size, format on save, default formatter
          # ════════════════════════════════════════════════════════════════
          "[typescript]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[javascript]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescriptreact]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[javascriptreact]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[astro]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "astro-build.astro-vscode";
          };
          "[css]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[scss]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[html]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[rust]" = {
            "editor.tabSize" = 4;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "rust-lang.rust-analyzer"; # rustfmt via rust-analyzer
          };
          "[python]" = {
            "editor.tabSize" = 4;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "charliermarsh.ruff";
            "editor.codeActionsOnSave" = {
              "source.fixAll.ruff" = "explicit";
              "source.organizeImports.ruff" = "explicit";
            };
          };
          "[nix]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          "[lua]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "sumneko.lua";
          };
          "[toml]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "tamasfe.even-better-toml"; # taplo
          };
          "[json]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
          };
          "[jsonc]" = {
            "editor.tabSize" = 2;
            "editor.formatOnSave" = true;
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
          "[shellscript]" = {
            "editor.tabSize" = 2;
          };
          "[xml]" = {
            "editor.tabSize" = 2;
          };
        };
      };
    };

    # ══════════════════════════════════════════════════════════════════════
    # Binary tambahan yang harus tersedia (LSP/formatter yang dipin di atas +
    # biar bisa dipanggil manual dari terminal juga). Setara `extraPackages`
    # punya Zed — bedanya module vscode home-manager gak punya opsi built-in
    # untuk ini, jadi pakai home.packages biasa.
    # ══════════════════════════════════════════════════════════════════════
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
