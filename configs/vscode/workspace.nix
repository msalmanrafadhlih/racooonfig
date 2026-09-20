{
  # ── Files ────────────────────────────────────────────────────────
  "files.autoSave" = "off";
  "files.hotExit" = "onExitAndWindowClose"; # setara session.restore_unsaved_buffers
  "files.trimTrailingWhitespace" = true;
  "files.insertFinalNewline" = true;
  "files.autoGuessEncoding" = true;

  # ── Search ───────────────────────────────────────────────────────
  "search.smartCase" = true;
  "search.useIgnoreFiles" = false; # ikut cari di file yang di-gitignore

  # ── Session & startup ────────────────────────────────────────────
  "window.confirmBeforeClose" = "always";
  "window.restoreWindows" = "none"; # jangan auto-reopen window terakhir
  "workbench.startupEditor" = "welcomePage"; # pendekatan terdekat ke "launchpad"
  "security.workspace.trust.enabled" = false; # setara session.trust_all_worktrees

  # ── Git ──────────────────────────────────────────────────────────
  "git.blame.editorDecoration.enabled" = true;
  "git.blame.statusBarItem.enabled" = true;
  "git.decorations.enabled" = true;
  "git.openRepositoryInParentFolders" = "always";

  # ── Extensions ───────────────────────────────────────────────────
  "extensions.ignoreRecommendations" = false;
}
