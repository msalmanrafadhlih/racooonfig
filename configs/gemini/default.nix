{
  mkSymlink,
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
    # home.file = mkSymlink {
    #   target = "gemini";
    # } configs;

    programs.antigravity-cli = {
      enable = true;

      # Menentukan default model yang otomatis mengisi environment variable $GEMINI_MODEL
      defaultModel = "gemini-2.5-flash";

      # Mengaktifkan integrasi dengan konfigurasi programs.mcp.servers (jika kamu menggunakannya)
      enableMcpIntegration = true;

      # Pengaturan umum UI/UX (disimpan ke ~/.gemini/antigravity-cli/settings.json)
      settings = {
        colorScheme = "tokyo night";
        altScreenMode = "always";
        toolPermission = "ask-user";
        artifactReviewPolicy = "agent-decides";
        context = {
          # Menyesuaikan nama file konteks yang akan dibaca
          fileName = [
            "GEMINI.md"
            "WORKSPACE.md"
          ];
        };
      };

      # Konfigurasi server MCP untuk kapabilitas tambahan
      mcpServers = {
        github = {
          serverUrl = "https://api.githubcopilot.com/mcp/";
        };
        filesystem = {
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-filesystem"
            "${home}/.repos" # Ganti dengan path direktori proyekmu
          ];
        };
      };

      # Mengatur perizinan spesifik untuk command sandbox/eksekusi
      permissions = {
        allow = [
          "command(git status)"
          "command(ls)"
          "command(cat *)"
        ];
        deny = [ "command(rm -rf *)" ];
        ask = [ "command(*)" ]; # Akan selalu bertanya sebelum menjalankan command lain
      };

      # Perintah kustom (akan di-generate menjadi struktur skill global)
      commands = {
        "git/fix" = {
          description = "Menganalisis perubahan git dan memberikan perbaikan kode.";
          prompt = "Tolong analisis perubahan yang di-stage dan berikan perbaikan untuk: {{args}}.";
        };
        "review" = {
          description = "Melakukan code review cepat.";
          prompt = "Tolong lakukan code review pada kode berikut dan berikan saran optimasi: {{args}}";
        };
      };

      # Konteks sistem global (disimpan sebagai file .md di ~/.gemini/)
      context = {
        GEMINI = ''
          # Global Context
          Kamu adalah asisten pengembang perangkat lunak yang ahli dalam NixOS.
          Gunakan gaya bahasa yang ringkas, padat, dan teknis. 
          Pastikan setiap baris kode Nix yang kamu hasilkan sudah sesuai standar.
        '';

        WORKSPACE = ''
          # Panduan Workspace
          Selalu periksa file `flake.nix` sebelum menyarankan perubahan konfigurasi.
        '';

        # Bisa juga menggunakan path ke file eksternal:
        # AGENTS = ./path/to/agents.md;
      };

      # Keahlian khusus/Custom Skills
      skills = {
        data-analyst = ''
          ---
          name: data-analyst
          description: Ahli dalam memanipulasi data dengan Python dan Pandas.
          ---
          Gunakan pustaka `pandas` untuk membaca file CSV yang diberikan pengguna. 
          Selalu tampilkan `df.head()` dan `df.describe()` sebagai langkah awal.
        '';

        # Bisa menggunakan path ke file markdown atau direktori penuh
        # nix-expert = ./skills/nix-expert/SKILL.md;
        # sysadmin = ./skills/sysadmin-dir;
      };
    };
  };
}
