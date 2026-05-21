{ inputs, pkgs, ... }:
let
  rip = "${inputs.racooonfig.packages.${pkgs.stdenv.hostPlatform.system}.rip}/bin/rip";
in
{
  programs.tmux.extraConfig = ''
  ##### rip : Process kill #####
  set-option -g command-alias[110] 'rip=display-menu -T "#[align=centre] 󰍜 RIP: Process Management " -x C -y C \
    "-"                  -  "" \
    "1    HANG UP"     1  "hangup" \
    "2    INTERRUPT"   2  "interrupt" \
    "3    QUIT"        3  "signal-quit" \
    "9    KILL"        4  "signal-kill" \
    "10   USR1"        5  "usr1" \
    "12   USR2"        6  "usr2" \
    "15   TERMINATE"   7  "terminate" \
    "18   CONTINUE"    8  "signal-continue" \
    "19   STOP"        9  "signal-stop" \
    "-"                -  "" \
    "PORTS"            p  "display-popup -w 65 -h 10 -y 100% -x C -B -T \" PORTS \" -E \"${rip} --ports --live\"" \
    "BTOP ++"          b  "display-popup -w 100 -h 35 -T \" Btop ++ \" -E \"btop -p 1\"" \
    "-"                -  "" \
    "↩ Quit"           q  ""'

  set-option -g command-alias[111] 'signal-kill=display-menu -T "#[align=centre] 🔪 Force Kill " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGKILL \" -E \"${rip} -s KILL --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGKILL \" -E \"${rip} -s KILL\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGKILL \" -E \"${rip} -s KILL --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGKILL \" -E \"${rip} -s KILL --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[112] 'hangup=display-menu -T "#[align=centre] 🔪 Reset Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGHUP \" -E \"${rip} -s HUP --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGHUP \" -E \"${rip} -s HUP\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGHUP \" -E \"${rip} -s HUP --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGHUP \" -E \"${rip} -s HUP --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[113] 'interrupt=display-menu -T "#[align=centre] 🔪 Interrupt ctrl + c " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNINT \" -E \"${rip} -s INT --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNINT \" -E \"${rip} -s INT\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNINT \" -E \"${rip} -s INT --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNINT \" -E \"${rip} -s INT --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[114] 'signal-quit=display-menu -T "#[align=centre] 🔪 QUIT the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNQUIT \" -E \"${rip} -s QUIT --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNQUIT \" -E \"${rip} -s QUIT\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNQUIT \" -E \"${rip} -s QUIT --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNQUIT \" -E \"${rip} -s QUIT --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[115] 'usr1=display-menu -T "#[align=centre] 🔪 USR1 the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"${rip} -s USR1 --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"${rip} -s USR1\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"${rip} -s USR1 --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNUSR1 \" -E \"${rip} -s USR1 --sort name\"" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[116] 'usr2=display-menu -T "#[align=centre] 🔪 USR2 the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"${rip} -s USR2 --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"${rip} -s USR2\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"${rip} -s USR2 --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNUSR2 \" -E \"${rip} -s USR2 --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[117] 'terminate=display-menu -T "#[align=centre] 🔪 Soft Kill " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNTERM \" -E \"${rip} -s TERM --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNTERM \" -E \"${rip} -s TERM\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNTERM \" -E \"${rip} -s TERM --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNTERM \" -E \"${rip} -s TERM --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[118] 'signal-continue=display-menu -T "#[align=centre] 🔪 CONT the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNCONT \" -E \"${rip} -s CONT --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNCONT \" -E \"${rip} -s CONT\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNCONT \" -E \"${rip} -s CONT --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNCONT \" -E \"${rip} -s CONT --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'

  set-option -g command-alias[119] 'signal-stop=display-menu -T "#[align=centre] 🔪 STOP the Process " -x C -y C \
    "-"                  -  "" \
    "sort by mem"        1  "display-popup -w 60 -T \" SIGNSTOP \" -E \"${rip} -s STOP --sort mem\"" \
    "sort by cpu"        2  "display-popup -w 60 -T \" SIGNSTOP \" -E \"${rip} -s STOP\"" \
    "sort by pid"        3  "display-popup -w 60 -T \" SIGNSTOP \" -E \"${rip} -s STOP --sort pid\"" \
    "sort by name"       4  "display-popup -w 60 -T \" SIGNSTOP \" -E \"${rip} -s STOP --sort name\"" \
    "-"                  -  "" \
    "↩ back"              q  "rip"'      
  '';
}
