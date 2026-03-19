{ config, dotfiles, lib, pkgs, ... }:

let
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  home = config.home.homeDirectory;
  dotfiles_path = "${home}/.dotfiles/${dotfiles}/configs/zed-editor";

  configs = {
		"zed/themes/racooonfig" = "themes/racooonfig";
  };
in

{
  # Symlink path to ~./config/*
  xdg.configFile = builtins.mapAttrs (name: subpath: {source =
    create_symlink "${dotfiles_path}/${subpath}";
    recursive = true;
  }) configs;

  programs.zed-editor = {
    enable = true;
    mutableUserKeymaps = true;
    mutableUserSettings = true;
    mutableUserDebug = true;
    mutableUserTasks = true;

    userKeymaps = import ./keymap.nix ;

    extensions = [ 
      "material_icon_theme"
      "nix" "toml" "elixir" "make" "lua" "python" "rust"
      "typescript" "marksman" "css" "scss" "kotlin"
      "java" "xml" "sql" "jsons" "bash"
    ];

    userSettings = {
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

      collaboration_panel = {
        default_width = 200.0;
        dock = "right";
      };

      notification_panel.default_width = 200.0;

      git_panel = {
        scrollbar.show = "never";
        tree_view = true;
        collapse_untracked_diff = true;
        sort_by_path = true;
        status_style = "icon";
        dock = "right";
        default_width = 200.0;
      };

      outline_panel = {
        auto_fold_dirs = true;
        auto_reveal_entries = true;
        indent_size = 10.0;
        default_width = 200.0;
        dock = "right";
      };

      document_symbols = "on";
      zoomed_padding = true;
      use_system_window_tabs = true;
      window_decorations = "client";

      preview_tabs = {
        enable_keep_preview_on_code_navigation = true;
        enable_preview_multibuffer_from_code_navigation = true;
        enable_preview_from_file_finder = true;
      };

      tab_bar.show_pinned_tabs_in_separate_row = true;

      title_bar = {
        show_branch_icon = false;
        show_menus = false;
      };

      tabs = {
        close_position = "left";
        file_icons = true;
        git_status = false;
      };

      project_panel = {
        sort_mode = "directories_first";
        hide_root = false;
        sticky_scroll = true;
        diagnostic_badges = true;
        scrollbar.show = "never";
        bold_folder_labels = false;
        starts_open = true;
        auto_reveal_entries = true;
        indent_size = 15.0;
        entry_spacing = "standard";
        hide_gitignore = false;
        default_width = 200.0;
        dock = "right";
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

      document_folding_ranges = "on";
      semantic_tokens = "off";

      image_viewer.unit = "binary";

      colorize_brackets = true;

      inlay_hints = {
        show_background = true;
        enabled = true;
      };

      indent_guides = {
        enabled = true;
        background_coloring = "disabled";
      };

      hard_tabs = false;
      tab_size = 4;

      hover_popover_enabled = true;
      snippet_sort_order = "inline";

      scroll_sensitivity = 1.0;
      vertical_scroll_margin = 3.0;
      scroll_beyond_last_line = "vertical_scroll_margin";

      excerpt_context_lines = 3;
      expand_excerpt_lines = 5;

      diff_view_style = "split";
      relative_line_numbers = "enabled";

      sticky_scroll.enabled = false;

      which_key.enabled = true;

      multi_cursor_modifier = "cmd_or_ctrl";

      text_rendering_mode = "platform_default";

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

      toolbar = {
        code_actions = true;
        selections_menu = true;
        breadcrumbs = true;
      };

      minimap = {
        max_width_columns = 70;
        thumb_border = "left_open";
        thumb = "hover";
        display_in = "active_editor";
      };

      gutter = {
        line_numbers = true;
        min_line_number_digits = 0;
        runnables = true;
        breakpoints = true;
        folds = true;
      };

      inline_code_actions = true;
      show_signature_help_after_edits = true;

      scrollbar = {
        selected_symbol = true;
        selected_text = true;
        git_diff = true;
        cursors = false;
        show = "system";
        axes.vertical = true;
        search_results = true;
      };

      icon_theme = "Material Icon Theme";
      format_on_save = "off";
      restore_on_startup = "last_session";

      agent_buffer_font_size = 8.0;

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

      active_pane_modifiers = {
        border_size = 0.1;
        inactive_opacity = 0.5;
      };

      agent_ui_font_size = 8.0;

      allow_rewrap = "in_comments";
      auto_indent = true;
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

      buffer_font_family = ".ZedMono";
      buffer_font_size = lib.mkForce 8.0;
      buffer_font_weight = 400;
      buffer_line_height = "standard";

      centered_layout = {
        left_padding = 0.2;
        right_padding = 0.2;
      };

      close_on_file_delete = false;
      confirm_quit = true;
      current_line_highlight = "gutter";
      diagnostics_max_severity = "all";
      disable_ai = false;
      double_click_in_multibuffer = "select";
      helix_mode = true;

      load_direnv = "direct";

      # ✅ FIXED (Nix-native, gak hardcode store path)
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      show_whitespaces = "selection";

      terminal = {
        scrollbar.show = "never";
        default_width = 620.0;
        option_as_meta = true;
        cursor_shape = "bar";
        font_size = 8.0;
        alternate_scroll = "on";
        blinking = "on";
        copy_on_select = true;

        detect_venv.on = {
          activate_script = "default";
          directories = [ ".env" "env" ".venv" "venv" ];
        };

        dock = "bottom";
        font_family = "FreeMono";
        line_height = "comfortable";

        shell.program = "sh";

        toolbar.breadcrumbs = true;

        working_directory = "current_project_directory";
      };

      theme = {
        mode = "system";
        light = "racooonfig";
        dark = "racooonfig";
      };

      ui_font_family = ".ZedMono";
      ui_font_size = lib.mkForce 9.0;

      vim_mode = false;
    };
  };
}
