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
in

{
  config = lib.mkIf (builtins.elem "zed-editor" cfg.listConfigurations) {
    xdg.configFile = mkSymlink {
      target = "zed-editor";
    } configs;

    programs.zed-editor = {
      enable = true;
      mutableUserKeymaps = true;
      mutableUserSettings = true;
      mutableUserDebug = true;
      mutableUserTasks = true;

      extensions = [
        "material_icon_theme"
        "nix"
        "slint"
        "toml"
        "elixir"
        "make"
        "lua"
        "python"
        "rust"
        "typescript"
        "marksman"
        "css"
        "scss"
        "kotlin"
        "java"
        "xml"
        "sql"
        "jsons"
        "bash"
      ];

      userSettings = lib.recursiveUpdate {

        redact_private_values = true;

        completions.lsp = false;
        linked_edits = false;
        use_system_path_prompts = false;
        lsp_highlight_debounce = 0;

        audio = {
          "experimental.rodio_audio" = true;
          "experimental.auto_microphone_volume" = true;
        };

        git = {
          path_style = "file_name_first";
          blame.show_avatar = true;
          inline_blame.show_commit_summary = true;
        };

        use_smartcase_search = true;

        search = {
          regex = true;
          include_ignored = true;
          case_sensitive = true;
          whole_word = true;
        };

        diagnostics = {
          lsp_pull_diagnostics = {
            debounce_ms = 0;
            enabled = false;
          };
          include_warnings = false;
          inline = {
            min_column = 0;
            padding = 4;
            enabled = false;
          };
        };

        prettier.allowed = true;
        semantic_tokens = "off";
        image_viewer.unit = "binary";

        hard_tabs = false;
        tab_size = 4;

        hover_popover_enabled = true;
        snippet_sort_order = "inline";

        which_key.enabled = true;
        multi_cursor_modifier = "cmd_or_ctrl";

        session = {
          restore_unsaved_buffers = true;
          trust_all_worktrees = true;
        };

        vim = {
          gdefault = true;
          use_smartcase_find = true;
          toggle_relative_line_numbers = true;
          cursor_shape = {
            visual = "underline";
            normal = "block";
            insert = "bar";
            replace = "hollow";
          };
        };

        inline_code_actions = true;
        show_signature_help_after_edits = true;
        format_on_save = "off";
        restore_on_startup = "last_session";

        agent = {
          show_turn_stats = true;
          message_editor_min_lines = 4;
          use_modifier_to_send = true;
          play_sound_when_agent_done = true;
          notify_when_agent_waiting = "all_screens";
          single_file_review = true;
          default_height = 320.0;
          default_width = 500.0;

          default_model = {
            provider = "copilot_chat";
            model = "gpt-5-mini";
          };
        };

        allow_rewrap = "in_comments";
        auto_indent = "syntax_aware";
        auto_indent_on_paste = true;

        auto_install_extensions = {
          material_icon_theme = true;
          bash = true;
          css = true;
          elixir = true;
          java = true;
          kotlin = true;
          lua = true;
          make = true;
          nix = true;
          python = true;
          rust = true;
          toml = true;
          typescript = true;
          jsons = true;
          marksman = true;
          scss = true;
          sql = true;
          xml = true;
        };

        auto_signature_help = true;
        auto_update = true;
        autosave = "off";
        autoscroll_on_clicks = true;

        base_keymap = "VSCode";

        close_on_file_delete = false;
        confirm_quit = true;
        current_line_highlight = "gutter";
        diagnostics_max_severity = "all";
        disable_ai = false;
        double_click_in_multibuffer = "select";
        helix_mode = true;
        vim_mode = false;

        load_direnv = "direct";

        # Path Node.js dieksekusi secara native melalui Nix Store
        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        terminal = {
          option_as_meta = true;
          copy_on_select = true;

          detect_venv.on = {
            activate_script = "default";
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
          };

          shell.program = "sh";
          working_directory = "current_project_directory";
        };
      } (builtins.fromJSON (builtins.readFile ./appearance.json));
    };
  };
}
