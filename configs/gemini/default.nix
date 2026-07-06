{
  mkSymlink,
  pkgs,
  lib,
  config,
  ...
}:
let
  home = config.home.homeDirectory;
  cfg = config.racooonfig;
  configs = {
    ".gemini/settings.json" = "./settings.json";
  };
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "gemini" cfg.listConfigurations) {
    home.file = {
      ".gemini/antigravity-cli/settings.json".force = true;
    }
    // mkSymlink {
      target = "gemini";
    } configs;

    programs.antigravity-cli = {
      enable = true;
      package = pkgs.antigravity-cli;

      # false = pakai path native Antigravity CLI (~/.gemini/antigravity-cli/...)
      # Set true kalau kamu justru pakai paket "gemini-cli" (biar path legacy dipakai otomatis).
      useLegacyGeminiConfig = false;
      defaultModel = "gemini-3.1-pro";

      # Ambil MCP servers dari programs.mcp.servers (kalau kamu pakai module MCP terpusat)
      enableMcpIntegration = true;

      settings = {
        colorScheme = "tokyo night";
        altScreenMode = "always";

        # "ask-user" lebih aman untuk sehari-hari; ganti ke "proceed-in-sandbox"
        # kalau kamu mau agent lebih otonom saat ngoding di sandbox/devenv shell.
        toolPermission = "proceed-in-sandbox";
        artifactReviewPolicy = "agent-decides";

        context = {
          fileName = [
            "AGENTS.md"
            "GEMINI.md"
            "WORKSPACE.md"
          ];
        };
      };

      # ============================================================
      # MCP SERVERS — kapabilitas tambahan buat ngoding
      # ============================================================
      mcpServers = {
        github = {
          serverUrl = "https://api.githubcopilot.com/mcp/";
        };

        filesystem = {
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-filesystem"
            "/etc/nixos"
            "${home}/.repos"
            "${home}/.config"
          ];
        };

        git = {
          command = "uvx";
          args = [
            "mcp-server-git"
            "--repository"
            "${home}/repos"
          ];
        };

        nixos = {
          command = "nix";
          args = [
            "run"
            "github:utensils/mcp-nixos"
            "--"
          ];
        };
      };

      permissions = {
        allow = [
          "command(git status)"
          "command(git diff *)"
          "command(git log *)"
          "command(ls *)"
          "command(cat *)"
          "command(rg *)"
          "command(fd *)"
          "command(cargo check)"
          "command(cargo build)"
          "command(cargo test)"
          "command(bun install)"
          "command(bun run *)"
          "command(nix flake check)"
          "command(nix build)"
        ];
        deny = [
          "command(rm -rf *)"
          "command(git push --force*)"
          "command(sudo *)"
          "command(dd *)"
        ];
        ask = [
          "command(*)"
        ];
      };

      # ============================================================
      # COMMANDS KUSTOM — jadi skill global "/nama-perintah"
      # ============================================================
      commands = {
        "git/fix" = {
          description = "Analisis perubahan staged git & berikan perbaikan kode.";
          prompt = "Tolong analisis perubahan yang di-stage (git diff --staged) dan berikan perbaikan untuk masalah ini: {{args}}.";
        };

        "review" = {
          description = "Code review cepat dengan fokus pada bug & performa.";
          prompt = ''
            Lakukan code review terhadap kode berikut. Fokus pada:
            1. Bug atau edge case yang terlewat
            2. Masalah performa
            3. Konsistensi gaya kode
            Berikan saran singkat dan konkret, sertakan contoh perbaikan bila perlu.

            Target/konteks: {{args}}
          '';
        };

        "test/gen" = {
          description = "Generate unit test untuk file/fungsi tertentu.";
          prompt = "Buatkan unit test yang mencakup happy path dan edge case untuk: {{args}}. Gunakan framework testing yang sudah dipakai di proyek ini.";
        };

        "nix/module" = {
          description = "Buatkan skeleton NixOS/home-manager module baru.";
          prompt = "Buatkan skeleton module Nix (NixOS atau home-manager, sesuaikan konteks) dengan options + config yang idiomatik untuk: {{args}}.";
        };

        "refactor" = {
          description = "Refactor kode tanpa mengubah perilaku (behavior-preserving).";
          prompt = "Refactor kode berikut agar lebih bersih dan idiomatik TANPA mengubah perilaku/behavior-nya. Jelaskan perubahan yang dilakukan: {{args}}.";
        };
      };

      # Konteks sistem global (disimpan sebagai file .md di ~/.gemini/)
      context = {
        AGENTS = ''
          # Global Agent Context

          Kamu adalah asisten pengembang perangkat lunak yang membantu Moch.
          Stack yang sering dipakai: Nix (flakes + devenv + home-manager), Rust (fenix + crane),
          Astro + Bun + Tailwind + SolidJS + DaisyUI, Android/Tauri mobile.

          ## Gaya Respons
          - Ringkas, padat, teknis. Hindari basa-basi.
          - Jika ragu antara beberapa pendekatan, sebutkan trade-off singkat, jangan bertele-tele.
          - Untuk kode Nix: ikuti gaya `nixpkgs-fmt` / `nixfmt`, hindari `with lib;` global di scope besar.

          ## Sebelum Membuat Perubahan
          - Selalu cek `flake.nix` / `flake.lock` sebelum menyarankan perubahan dependency.
          - Jangan asumsikan versi paket; cek dulu kalau memungkinkan.
        '';

        WORKSPACE = ''
          # Panduan Workspace

          - Proyek Nix template ada di monorepo `nix.templates` (Rust, Bun, Node.js, Flutter, Tauri).
          - Selalu pisahkan devShell module dari devenv module (hindari scoping bug `devenvModules`).
          - Untuk Rust: pakai `fenix` + `crane`, bukan `rustPlatform` bawaan kecuali diminta eksplisit.
        '';
      };

      skills = {
        nix-flakes = ''
          ---
          name: nix-flakes
          description: Ahli dalam Nix flakes, devenv, dan home-manager modules. Gunakan saat membuat/mengedit flake.nix, devShell, atau module home-manager.
          ---

          # Nix Flakes & devenv Expert

          - Pisahkan `devenvModules` dari `devShells` untuk menghindari scoping bug.
          - Gunakan `flake-parts` bila proyek makin kompleks (multi-system, multi-output).
          - Untuk `devenv.lib.mkShell`, pastikan signature sesuai versi devenv yang dipakai —
            cek changelog devenv kalau ada error signature mismatch.
          - Selalu jalankan `nix flake check` sebelum menganggap konfigurasi selesai.
        '';

        rust-fenix-crane = ''
          ---
          name: rust-fenix-crane
          description: Membantu setup Rust build dengan fenix (toolchain) dan crane (incremental cargo build). Gunakan untuk proyek Rust/Tauri.
          ---

          # Rust dengan fenix + crane

          - `fenix` dipakai untuk pin toolchain Rust (stable/nightly/versi spesifik).
          - `crane` dipakai untuk build cargo project secara incremental & cached di Nix.
          - Untuk target Android (Tauri mobile), pastikan target triple (mis. `aarch64-linux-android`)
            sudah ditambahkan lewat fenix combine, dan NDK sudah tersedia di devShell.
        '';

        frontend-astro-solid = ''
          ---
          name: frontend-astro-solid
          description: Membantu development stack Astro + Bun + Tailwind + SolidJS + DaisyUI. Gunakan untuk komponen web, styling, dan integrasi island.
          ---

          # Astro + SolidJS Stack

          - Perhatikan boundary serialization antara Astro island dan komponen SolidJS
            (props harus serializable, hindari passing function langsung tanpa client directive yang tepat).
          - Gunakan Tailwind v4 + DaisyUI, cek `tailwind.config` untuk path alias yang benar.
          - Untuk deploy: target Cloudflare Pages, pastikan build output sesuai adapter yang dipakai.
        '';

        # Alternatif: pakai direktori skill penuh (dengan referensi/script tambahan)
        # data-analyst = ./skills/data-analyst;
      };
    };
  };
}
