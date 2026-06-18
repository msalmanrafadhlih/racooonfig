{
  lib,
  pkgs,
  mkSymlink,
  config,
  ...
}:

let
  configs = {
    "zed/themes/racooonfig.json" = "themes/racooonfig.json";
    "zed/keymap.json" = "./keymap.json";
  };
  cfg = config.racooonfig;

  # ── Helper: inlay hints TypeScript/JavaScript yang identik ────────────────
  # Dipakai ulang di blok `typescript` dan `javascript` dalam vtsls settings.
  tsInlayHints = {
    parameterNames = {
      enabled = "all";
      suppressWhenArgumentMatchesName = false;
    };
    parameterTypes.enabled = true;
    variableTypes = {
      enabled = true;
      suppressWhenTypeMatchesName = false;
    };
    propertyDeclarationTypes.enabled = true;
    functionLikeReturnTypes.enabled = true;
    enumMemberValues.enabled = true;
  };
in

{
  config = lib.mkIf (cfg.homeManager && builtins.elem "zed-editor" cfg.listConfigurations) {
    xdg.configFile = mkSymlink {
      target = "zed-editor";
    } configs;

    programs.zed-editor = {
      enable = true;
      mutableUserKeymaps = true;
      mutableUserSettings = true;
      mutableUserDebug = true;
      mutableUserTasks = true;

      # ── Extensions ──────────────────────────────────────────────────────────
      extensions = [
        "material_icon_theme"
        # Web Dev
        "html"
        "astro"
        "typescript" # menangani TS, JS, TSX, JSX, React, Solid
        "css"
        "scss"
        "tailwindcss"
        # Systems
        "rust"
        # Scripting / Data
        "python"
        "lua"
        # DevOps / Config
        "nix"
        "bash"
        "make"
        "toml"
        # Data Formats
        "jsons"    # JSON + JSON5
        "xml"
        "sql"
        # Docs
        "marksman" # Markdown + LSP
      ];

      userSettings = lib.recursiveUpdate {
        # ════════════════════════════════════════════════════════════════════════
        # PERILAKU EDITOR
        # ════════════════════════════════════════════════════════════════════════
        redact_private_values = true;

        hard_tabs = false;
        tab_size = 2;                      # Default web dev; override per-bahasa di bawah

        hover_popover_enabled = true;
        current_line_highlight = "gutter";
        linked_edits = true;               # Sinkron tag HTML/JSX berpasangan
        double_click_in_multibuffer = "select";
        autoscroll_on_clicks = true;

        multi_cursor_modifier = "cmd_or_ctrl";
        snippet_sort_order = "inline";

        allow_rewrap = "in_comments";
        auto_indent = "syntax_aware";
        auto_indent_on_paste = true;

        use_system_path_prompts = false;
        load_direnv = "direct";            # Krusial agar devShells terbaca

        image_viewer.unit = "binary";

        # ════════════════════════════════════════════════════════════════════════
        # AUTOCOMPLETION — LAYAKNYA VSCODE
        # ════════════════════════════════════════════════════════════════════════

        # Completion popup muncul langsung saat mengetik (tanpa Ctrl+Space)
        show_completions_on_input = true;
        show_completion_documentation = true;
        # completion_documentation_secondary_query_debounce = 300;

        # Signature help otomatis (tampil parameter saat memanggil fungsi)
        auto_signature_help = true;
        show_signature_help_after_edits = true;

        # Inlay hints — anotasi tipe inline seperti VSCode dengan TypeScript
        inlay_hints = {
          enabled = true;
          show_type_hints = true;
          show_parameter_hints = true;
          show_other_hints = true;
          edit_debounce_ms = 700;
          scroll_debounce_ms = 50;
        };

        # Inline completion (Copilot-style ghost text)
        # Opsi: "copilot" | "supermaven" | "zed" | "none"
        features.inline_completion_provider = "copilot";

        # ════════════════════════════════════════════════════════════════════════
        # CODE INTELLIGENCE
        # ════════════════════════════════════════════════════════════════════════

        inline_code_actions = true;
        code_lens = "on";
        semantic_tokens = "combined";            # Syntax highlight akurat dari LSP
        lsp_highlight_debounce = 75;       # ms; 0 = boros CPU tanpa manfaat nyata

        # ════════════════════════════════════════════════════════════════════════
        # FORMAT & DIAGNOSTICS
        # ════════════════════════════════════════════════════════════════════════

        # Global: off — setiap bahasa aktifkan sendiri di blok `languages`
        format_on_save = "off";
        prettier.allowed = true;           # Izinkan Zed pakai prettier bawaan

        diagnostics = {
          include_warnings = true;
          lsp_pull_diagnostics = {
            enabled = true;
            debounce_ms = 150;
          };
          inline = {
            enabled = true;
            min_column = 0;
            padding = 4;
          };
        };

        # ════════════════════════════════════════════════════════════════════════
        # GIT
        # ════════════════════════════════════════════════════════════════════════

        git = {
          path_style = "file_name_first";
          blame.show_avatar = true;
          inline_blame.show_commit_summary = true;
        };

        # ════════════════════════════════════════════════════════════════════════
        # SEARCH
        # ════════════════════════════════════════════════════════════════════════

        use_smartcase_search = true;
        search = {
          regex = true;
          include_ignored = true;
          case_sensitive = false;          # FIX: konflik dengan smartcase jika true
          whole_word = false;
        };

        # ════════════════════════════════════════════════════════════════════════
        # SESSION & STARTUP
        # ════════════════════════════════════════════════════════════════════════

        restore_on_startup = "last_session";
        autosave = "off";
        confirm_quit = true;
        close_on_file_delete = false;

        session = {
          restore_unsaved_buffers = true;
          trust_all_worktrees = true;
        };

        # ════════════════════════════════════════════════════════════════════════
        # MODE & KEYMAP
        # ════════════════════════════════════════════════════════════════════════

        helix_mode = true;
        vim_mode = false;
        base_keymap = "VSCode";

        # ════════════════════════════════════════════════════════════════════════
        # EXTENSIONS & UPDATE
        # ════════════════════════════════════════════════════════════════════════

        auto_update = false;              # FIX: Nix yang kelola versi Zed

        auto_install_extensions = {
          material_icon_theme = true;
          html = true;
          astro = true;
          typescript = true;
          css = true;
          scss = true;
          tailwindcss = true;
          rust = true;
          python = true;
          lua = true;
          nix = true;
          bash = true;
          make = true;
          toml = true;
          jsons = true;
          xml = true;
          sql = true;
          marksman = true;
        };

        # ════════════════════════════════════════════════════════════════════════
        # TERMINAL
        # ════════════════════════════════════════════════════════════════════════

        terminal = {
          copy_on_select = true;
          detect_venv.on = {
            activate_script = "default";
            directories = [ ".venv" "venv" ".env" "env" ];
          };
          working_directory = "current_project_directory";
        };

        # ════════════════════════════════════════════════════════════════════════
        # NODE.JS — dari Nix Store
        # ════════════════════════════════════════════════════════════════════════

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        # ════════════════════════════════════════════════════════════════════════
        # PER-LANGUAGE SETTINGS
        # ════════════════════════════════════════════════════════════════════════

        languages = {

          # ── Web: TypeScript / JavaScript ─────────────────────────────────────
          TypeScript = {
            tab_size = 2;
            format_on_save = "on";
          };

          JavaScript = {
            tab_size = 2;
            format_on_save = "on";
          };

          # TSX: React / Solid — Tailwind aktif
          TSX = {
            tab_size = 2;
            format_on_save = "on";
            language_servers = [
              "vtsls"
              "tailwindcss-language-server"
            ];
          };

          # JSX: React / Solid — Tailwind aktif
          JSX = {
            tab_size = 2;
            format_on_save = "on";
            language_servers = [
              "vtsls"
              "tailwindcss-language-server"
            ];
          };

          # ── Web: Astro ───────────────────────────────────────────────────────
          Astro = {
            tab_size = 2;
            format_on_save = "on";
            language_servers = [
              "astro-language-server"
              "tailwindcss-language-server"
            ];
          };

          # ── Web: CSS / SCSS ──────────────────────────────────────────────────
          CSS = {
            tab_size = 2;
            format_on_save = "on";
            language_servers = [
              "vscode-css-language-server"
              "tailwindcss-language-server"
            ];
          };

          SCSS = {
            tab_size = 2;
            format_on_save = "on";
            language_servers = [
              "vscode-css-language-server"
              "tailwindcss-language-server"
            ];
          };

          # ── Web: HTML ────────────────────────────────────────────────────────
          HTML = {
            tab_size = 2;
            format_on_save = "on";
            language_servers = [
              "vscode-html-language-server"
              "tailwindcss-language-server"
            ];
          };

          # ── Rust ─────────────────────────────────────────────────────────────
          Rust = {
            tab_size = 4;
            format_on_save = "on";
            formatter = "language_server"; # rustfmt via rust-analyzer
          };

          # ── Python ───────────────────────────────────────────────────────────
          Python = {
            tab_size = 4;
            format_on_save = "on";
            formatter = {
              external = {
                command = "ruff";
                arguments = [
                  "format"
                  "--stdin-filename"
                  "{buffer_path}"
                  "-"
                ];
              };
            };
            language_servers = [ "pyright" "ruff" ];
          };

          # ── Nix ──────────────────────────────────────────────────────────────
          Nix = {
            tab_size = 2;
            format_on_save = "on";
            formatter = {
              external = {
                # Ganti ke pkgs.nixfmt jika lebih suka style lama
                command = lib.getExe pkgs.nixfmt-rfc-style;
                arguments = [ "-" ];
              };
            };
          };

          # ── Lua ──────────────────────────────────────────────────────────────
          Lua = {
            tab_size = 2;
            format_on_save = "on";
            formatter = "language_server"; # stylua via lua-language-server
          };

          # ── TOML ─────────────────────────────────────────────────────────────
          TOML = {
            tab_size = 2;
            format_on_save = "on";
            formatter = "language_server"; # taplo
          };

          # ── JSON ─────────────────────────────────────────────────────────────
          JSON = {
            tab_size = 2;
            format_on_save = "on";
          };

          # ── Markdown ─────────────────────────────────────────────────────────
          Markdown = {
            tab_size = 2;
            soft_wrap = "editor_width";
            format_on_save = "on";
          };

          # ── Makefile — WAJIB hard tab ─────────────────────────────────────
          Makefile = {
            hard_tabs = true;
          };

          # ── Sisanya ───────────────────────────────────────────────────────────
          SQL = { tab_size = 2; };
          Bash = { tab_size = 2; };
          XML = { tab_size = 2; };
        };

        # ════════════════════════════════════════════════════════════════════════
        # LSP CONFIGURATION
        # ════════════════════════════════════════════════════════════════════════

        lsp = {

          # ── vtsls: TypeScript & JavaScript (termasuk React, Solid, Astro TS) ─
          vtsls = {
            settings = {
              vtsls = {
                enableMoveToFileCodeAction = true;
                autoUseWorkspaceTsdk = true;        # Prioritaskan TS di node_modules
                experimental.completion = {
                  enableServerSideFuzzyMatch = true; # Fuzzy match completion lebih akurat
                };
              };
              typescript = {
                suggest.completeFunctionCalls = true; # Auto-isi parameter saat complete
                updateImportsOnFileMove.enabled = "always";
                preferences.includePackageJsonAutoImports = "auto";
                inlayHints = tsInlayHints;
                referencesCodeLens = {
                  enabled = true;
                  showOnAllFunctions = true;
                };
                implementationsCodeLens = {
                  enabled = true;
                  showOnAllClassMethods = true;
                  showOnInterfaceMethods = true;
                };
              };
              javascript = {
                suggest.completeFunctionCalls = true;
                updateImportsOnFileMove.enabled = "always";
                inlayHints = tsInlayHints;
              };
            };
          };

          # ── Astro Language Server ────────────────────────────────────────────
          "astro-language-server" = {
            settings = {
              typescript = {
                # Fallback ke TypeScript dari Nix Store jika tidak ada di node_modules.
                # Zed akan otomatis memilih TS lokal proyek jika tersedia (via direnv).
                tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
              };
            };
          };

          # ── Tailwind CSS Language Server ─────────────────────────────────────
          "tailwindcss-language-server" = {
            settings = {
              includeLanguages = {
                astro = "html";
                javascript = "javascript";
                typescript = "javascript";
                typescriptreact = "html";
                vue = "html";
              };
              # Fungsi class utility populer (cva, clsx, dll.)
              classFunctions = [
                "cva"
                "cx"
                "clsx"
                "cn"
                "twMerge"
                "tv"
                "ctl"
              ];
              experimental.classRegex = [
                # JSX className (string biasa & template literal)
                ''className="([^"]*)"''
                ''className=\{`([^`]*)`\}''
                # HTML class
                ''class="([^"]*)"''
                # Astro class:list
                ''class:list=\[([^\]]*)\]''
                # Utility functions
                ''\bcva\(([^)]*)\)''
                ''\bclsx\(([^)]*)\)''
                ''\bcn\(([^)]*)\)''
                ''\bcx\(([^)]*)\)''
                ''\btv\(([^)]*)\)''
                ''\btwMerge\(([^)]*)\)''
              ];
            };
          };

          # ── rust-analyzer ────────────────────────────────────────────────────
          "rust-analyzer" = {
            initialization_options = {
              # Gunakan clippy saat save (lebih lengkap dari cargo check)
              checkOnSave = true;
              check.command = "clippy";

              cargo = {
                allFeatures = true;
                loadOutDirsFromCheck = true;
                buildScripts.enable = true;
              };

              procMacro.enable = true;

              completion = {
                callable.snippets = "fill_arguments"; # Auto-isi argumen saat complete
                fullFunctionSignatures.enable = true;
                postfix.enable = true;
              };

              # Inlay hints Rust — paling lengkap dari semua LSP
              inlayHints = {
                parameterHints.enable = true;
                typeHints = {
                  enable = true;
                  hideClosureInitialization = false;
                  hideNamedConstructor = false;
                };
                chainingHints.enable = true;
                bindingModeHints.enable = true;
                closureReturnTypeHints.enable = "with_block";
                lifetimeElisionHints = {
                  enable = "skip_trivial";
                  useParameterNames = true;
                };
                discriminantHints.enable = "fieldless";
                expressionAdjustmentHints.enable = "reborrow";
                reborrowHints.enable = "mutable";
                closingBraceHints = {
                  enable = true;
                  minLines = 10;
                };
                maxLength = 30;
                renderColons = true;
              };

              hover.actions = {
                references.enable = true;
                run.enable = true;
                debug.enable = true;
              };

              # Code lens: tampilkan jumlah referensi, implementasi, dll.
              lens = {
                enable = true;
                references.adt.enable = true;
                references.enumVariant.enable = true;
                references.method.enable = true;
                references.trait.enable = true;
              };
            };
          };

          # ── Pyright: Type checker Python ─────────────────────────────────────
          pyright = {
            settings = {
              python.analysis = {
                typeCheckingMode = "standard";
                autoImportCompletions = true;
                autoSearchPaths = true;
                useLibraryCodeForTypes = true;
                diagnosticMode = "workspace";
                inlayHints = {
                  variableTypes = true;
                  functionReturnTypes = true;
                  callArgumentNames = true;
                  pytestParameters = true;
                };
              };
            };
          };

          # ── Ruff: Linter & Formatter Python ──────────────────────────────────
          ruff = {
            initialization_options.settings = {
              lineLength = 88;
              lint = {
                select = [
                  "E" "F" "W"   # pycodestyle, pyflakes
                  "I"           # isort
                  "N" "UP"      # naming, pyupgrade
                  "B" "A" "C4"  # bugbear, builtins, comprehensions
                  "SIM" "RET"   # simplify, return
                  "PL" "RUF"    # pylint, ruff-specific
                ];
                ignore = [
                  "E501" # line too long — dihandle oleh formatter
                ];
              };
            };
          };

          # ── lua-language-server ───────────────────────────────────────────────
          lua-language-server = {
            settings.Lua = {
              runtime.version = "LuaJIT";
              # Globals umum: Neovim (vim), Hammerspoon (hs), AwesomeWM
              diagnostics.globals = [ "vim" "hs" "awesome" "client" "screen" ];
              workspace.checkThirdParty = false;
              hint = {
                enable = true;
                setType = true;
                paramType = true;
                paramName = "All";
                arrayIndex = "Enable";
              };
              completion = {
                enable = true;
                showParams = true;
                callSnippet = "Replace"; # Snippet saat complete fungsi
              };
              format.enable = true;
            };
          };

          # ── nixd: Nix Language Server ─────────────────────────────────────────
          nixd = {
            settings.nixd = {
              formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
              diagnostic.suppress = [ "sema-escaping-with" ];
            };
          };

          # ── vscode-json-language-server ───────────────────────────────────────
          # "vscode-json-language-server" = {
          #   initialization_options.provideFormatter = true;
          # };

          # ── bash-language-server ──────────────────────────────────────────────
          "bash-language-server" = {
            settings.bashIde = {
              globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)";
              enableSourceErrorDiagnostics = true;
              shellcheckPath = lib.getExe pkgs.shellcheck;
            };
          };

          # ── taplo: TOML ───────────────────────────────────────────────────────
          # taplo = { };

          # ── marksman: Markdown ────────────────────────────────────────────────
          marksman = { };

        }; # end lsp
      } (builtins.fromJSON (builtins.readFile ./appearance.json)); # end userSettings
    }; # end programs.zed-editor
  }; # end config
}
