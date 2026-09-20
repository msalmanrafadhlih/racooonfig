{
  aichat = {
    "github.copilot.enable" = {
      "*" = true;
    };
    "github.copilot.nextEditSuggestions.enabled" = true; # edit predictions
    "github.copilot.chat.terminalChatLocation" = "terminal";

    # ── Agent ────────────────────────────────────────────────────────
    "chat.agent.enabled" = true;
    "chat.checkpoints.enabled" = false;
    "chat.checkpoints.showFileChanges" = true;

    # Auto-approve command tertentu di terminal agent — setara
    # `tool_permissions.tools.terminal.always_allow` punya Zed. Beda
    # sintaks: VSCode pakai string "/regex/": true, bukan {pattern=...}.
    "chat.tools.terminal.enableAutoApprove" = true;
    "chat.tools.terminal.autoApprove" = {
      "/^cargo\\s+(build|check|test|clippy|fmt)\\b/" = true;
      "/^(npm|pnpm|bun)\\s+(install|run|test)\\b/" = true;
    };
    # Catatan: belum ada padanan persis untuk `edit_file.always_deny` punya Zed
    # (deny-list pola file yang tidak boleh diedit agent).
  };
}
