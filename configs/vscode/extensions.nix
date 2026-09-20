# Daftar extension. Dipanggil sebagai fungsi: import ./extensions.nix { inherit pkgs; }
{ pkgs, ... }:

with pkgs.vscode-extensions;
[
  # ── Tema ─────────────────────────────────────────────────────────
  vscode-icons-team.vscode-icons

  # ── Web ──────────────────────────────────────────────────────────
  # html/css/json/typescript dasar sudah bawaan VSCode
  astro-build.astro-vscode
  bradlc.vscode-tailwindcss
  esbenp.prettier-vscode
  formulahendry.auto-complete-tag
  pranaygp.vscode-css-peek
  sporiley.css-auto-prefix
  wix.vscode-import-cost

  # ── Bahasa & LSP ─────────────────────────────────────────────────
  rust-lang.rust-analyzer
  ms-python.python
  ms-python.vscode-pylance # ⚠ unfree — pastikan allowUnfree aktif
  charliermarsh.ruff
  sumneko.lua
  jnoortheen.nix-ide
  mads-hartmann.bash-ide-vscode
  timonwong.shellcheck

  # ── DevOps / Config ──────────────────────────────────────────────
  mkhl.direnv # setara `load_direnv = "direct"` punya Zed
  ms-azuretools.vscode-docker # handle Dockerfile + docker-compose; default bawaannya sudah nyaman
  ms-vscode.makefile-tools
  tamasfe.even-better-toml
  mikestead.dotenv
  skellock.just

  # ── Data & dokumen ───────────────────────────────────────────────
  redhat.vscode-xml
  yzhang.markdown-all-in-one

  # ── Bantuan editor & diagnostik ──────────────────────────────────
  christian-kohler.path-intellisense
  formulahendry.code-runner
  oderwat.indent-rainbow
  usernamehw.errorlens

  # ── AI ───────────────────────────────────────────────────────────
  github.copilot
  github.copilot-chat
]
