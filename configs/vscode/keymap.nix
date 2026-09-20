{
  "multiCommand.commands" = [
    {
      command = "multiCommand.toggleFocusEditor";
      sequence = [
        "workbench.action.closeSidebar"
        "workbench.action.activityBarLocation.hide"
        "workbench.action.closePanel"
        "workbench.action.focusActiveEditorGroup"
      ];
    }
    {
      command = "multiCommand.focusFromSearch";
      sequence = [
        "workbench.action.focusActiveEditorGroup"
        "workbench.view.search.toggleVisibility"
      ];
    }
    {
      command = "multiCommand.cursorDown5";
      sequence = builtins.genList (_: "cursorDown") 5;
    }
    {
      command = "multiCommand.cursorUp5";
      sequence = builtins.genList (_: "cursorUp") 5;
    }
  ];
}
