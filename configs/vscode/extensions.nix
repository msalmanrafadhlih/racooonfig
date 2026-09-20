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
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag
  pranaygp.vscode-css-peek
  wix.vscode-import-cost

  # ── Bahasa & LSP ─────────────────────────────────────────────────
  rust-lang.rust-analyzer
  ms-python.python
  ms-python.vscode-pylance
  charliermarsh.ruff
  sumneko.lua
  jnoortheen.nix-ide
  mads-hartmann.bash-ide-vscode
  timonwong.shellcheck

  # ── DevOps / Config ──────────────────────────────────────────────
  mkhl.direnv 
  ms-azuretools.vscode-docker 
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
