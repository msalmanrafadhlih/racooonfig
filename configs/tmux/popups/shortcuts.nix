{ ... }:

{
  programs.tmux.extraConfig = ''

set-option -g command-alias[98] "shortcuts=display-popup -T \" >_ Tmux shortcuts \" -w 45 -h 80% -y 100% -x R -E \"echo '
╔════════════════════════════════════════╗
║            PURPLELITE TMUX             ║
╚════════════════════════════════════════╝
\\sPREFIX:                            Ctrl+z
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\s-- CORE --
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\sCtrl+z         r            Reload config
\\sCtrl+z        C-m            Toggle mouse
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\s-- PANES --
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\sCtrl+z         |           Split vertical
\\sCtrl+z         -         Split horizontal
\\sCtrl+z         x                Kill pane

\\sCtrl+z         l  Navigate to RIGHT(pane)
\\sCtrl+z         h   Navigate to LEFT(pane)
\\sCtrl+z         k     Navigate to UP(pane)
\\sCtrl+z         j   Navigate to DOWN(pane)

\\sCtrl+Alt      h,j,k,l        Resize panes
\\sCtrl+z           z            (tmux zoom)

\\sCopy Mode (vi):
\\s        v                 Begin selection
\\s        r                Rectangle toggle
\\s        y       Copy to clipboard (xclip)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\s-- WINDOWS --
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\sCtrl+z          n              New window
\\sCtrl+z          ,           Rename window

\\sAlt             h         Previous window
\\sAlt             l             Next window
\\sCtrl            ]             Next window

\\sAlt             1-5         Change layout
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\s-- SESSIONS ---
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\sCtrl+z          N             New session
\\sCtrl+z          K            Kill session
\\sCtrl+z          .          Rename session

\\sAlt             k            Next session
\\sAlt             j        Previous session
\\sAlt             o            Last session
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\s-- POPUPS --
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\sCtrl+z        C-s      Session Management
\\sCtrl+z        C-w           NixOS Rebuild

\\s--- MENU ---
\\sctrl+z         m                Open Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\s-- PERFORMANCE MODE --
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\sEscape-time      0 (instant key response)
\\sHistory-limit                100000 lines
\\sAggressive resize                 enabled
\\sFocus events                      enabled
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
\\s            Press q to exit.
' | less\""

bind ? shortcuts

  '';
}
