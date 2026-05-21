{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ###################################################
    ###########    SESSION MANAGER    ################# 
    (writeShellScriptBin "tmux-session-manager" ''
      #!/usr/bin/env bash
    
      # 1. Ambil nama sesi saat ini agar tidak muncul di daftar
      current=$(tmux display-message -p '#S')
    
      # 2. Jalankan fzf dengan bind navigasi dan hapus (delete)
      # ctrl-d akan kill sesi yang disorot, lalu me-reload daftar sesi fzf
      output=$(tmux list-sessions -F '#S' 2>/dev/null | grep -v -x "$current" | \
        fzf --reverse --prompt="Session> " --print-query \
            --header "Enter: Switch/Create | Ctrl-D: Del | Ctrl-J/K: Navigator" \
            --bind "ctrl-j:down,ctrl-k:up" \
            --bind "ctrl-d:execute(tmux kill-session -t {})+reload(tmux list-sessions -F '#S' 2>/dev/null | grep -v -x '$current')" \
            --bind "q:abort"
      )
    
      # 3. Parsing output dari fzf --print-query
      # Baris 1: teks yang diketik (query)
      # Baris 2: item yang dipilih dari list (jika ada)
      query=$(echo "$output" | head -n 1)
      selected=$(echo "$output" | tail -n 1)
    
      # Batal jika user menekan Esc/Ctrl-c (output kosong)
      if [ -z "$query" ] && [ -z "$selected" ]; then
          exit 0
      fi
    
      # Prioritaskan item yang dipilih, jika tidak ada, gunakan teks yang diketik
      target="''${selected:-$query}"
    
      # 4. Eksekusi: Coba pindah sesi. Jika gagal (sesi tidak ada), buat baru lalu pindah.
      if ! tmux switch-client -t "$target" 2>/dev/null; then
          tmux new-session -d -s "$target"
          tmux switch-client -t "$target"
      fi
    '')
  ];
}
