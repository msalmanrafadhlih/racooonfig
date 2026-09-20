# Rust: rust-analyzer. Sama persis dengan lsp.rust-analyzer punya Zed, cuma
# diratakan ke gaya key VSCode "rust-analyzer.<path>". `server.path` WAJIB
# di-pin ke Nix store — extension ini defaultnya download binary sendiri,
# yang gak akan jalan di NixOS tanpa nix-ld.
{ lib, pkgs, ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "rust-analyzer.server.path" = lib.getExe pkgs.rust-analyzer;
    "rust-analyzer.check.command" = "clippy";
    "rust-analyzer.cargo.allFeatures" = true;
    "rust-analyzer.cargo.buildScripts.enable" = true;
    "rust-analyzer.procMacro.enable" = true;

    "rust-analyzer.completion.callable.snippets" = "fill_arguments";
    "rust-analyzer.completion.fullFunctionSignatures.enable" = true;
    "rust-analyzer.completion.postfix.enable" = true;

    "rust-analyzer.inlayHints.parameterHints.enable" = true;
    "rust-analyzer.inlayHints.typeHints.enable" = true;
    "rust-analyzer.inlayHints.typeHints.hideClosureInitialization" = false;
    "rust-analyzer.inlayHints.typeHints.hideNamedConstructor" = false;
    "rust-analyzer.inlayHints.chainingHints.enable" = true;
    "rust-analyzer.inlayHints.bindingModeHints.enable" = true;
    "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "with_block";
    "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = "skip_trivial";
    "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;
    "rust-analyzer.inlayHints.discriminantHints.enable" = "fieldless";
    "rust-analyzer.inlayHints.expressionAdjustmentHints.enable" = "reborrow";
    "rust-analyzer.inlayHints.reborrowHints.enable" = "mutable";
    "rust-analyzer.inlayHints.closingBraceHints.enable" = true;
    "rust-analyzer.inlayHints.closingBraceHints.minLines" = 10;
    "rust-analyzer.inlayHints.maxLength" = 30;
    "rust-analyzer.inlayHints.renderColons" = true;

    "rust-analyzer.hover.actions.references.enable" = true;
    "rust-analyzer.hover.actions.run.enable" = true;
    "rust-analyzer.hover.actions.debug.enable" = true;

    "rust-analyzer.lens.enable" = true;
    "rust-analyzer.lens.references.adt.enable" = true;
    "rust-analyzer.lens.references.enumVariant.enable" = true;
    "rust-analyzer.lens.references.method.enable" = true;
    "rust-analyzer.lens.references.trait.enable" = true;

    "[rust]" = {
      "editor.tabSize" = 4;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "rust-lang.rust-analyzer"; # rustfmt via rust-analyzer
    };
  };
}
