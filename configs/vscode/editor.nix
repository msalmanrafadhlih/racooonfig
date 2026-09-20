{
  # ── Indentasi ────────────────────────────────────────────────────
  "editor.insertSpaces" = true;
  "editor.tabSize" = 2; # default web dev; override per-bahasa di languages/
  "editor.detectIndentation" = true;
  "editor.autoIndent" = "advanced";
  "editor.linkedEditing" = true; # sinkron tag HTML/JSX berpasangan
  "editor.multiCursorModifier" = "ctrlCmd";

  # ── Autocompletion ───────────────────────────────────────────────
  "editor.quickSuggestions" = {
    other = true;
    comments = false;
    strings = true; # perlu true supaya IntelliSense Tailwind jalan di className/class
  };
  "editor.suggestOnTriggerCharacters" = true;
  "editor.tabCompletion" = "on";
  "editor.snippetSuggestions" = "top";
  "editor.parameterHints.enabled" = true;
  "emmet.triggerExpansionOnTab" = true;

  # ── Code intelligence ────────────────────────────────────────────
  "editor.inlayHints.enabled" = "on"; # anotasi tipe inline
  "editor.lightbulb.enabled" = "onCode";
  "editor.codeLens" = true;
  "editor.semanticHighlighting.enabled" = true;
  "editor.hover.above" = true;
  "editor.links" = true;

  # ── Format ───────────────────────────────────────────────────────
  "editor.defaultFormatter" = "esbenp.prettier-vscode";
  # Global: off — tiap bahasa aktifkan sendiri di blok "[bahasa]" (languages/)
  "editor.formatOnSave" = false;
  "editor.formatOnPaste" = true;

  # ── Diff ─────────────────────────────────────────────────────────
  "diffEditor.ignoreTrimWhitespace" = false;

  # ── Diagnostics ──────────────────────────────────────────────────
  # Error Lens — diagnostic inline (bawaan Zed, extension di VSCode)
  "errorLens.enabledDiagnosticLevels" = [
    "error"
    "warning"
    "info"
  ];
}
