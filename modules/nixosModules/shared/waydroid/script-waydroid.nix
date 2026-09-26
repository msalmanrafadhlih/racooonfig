# waydroid-launcher — CLI wrapper yang otomatis init/start Waydroid lalu
# langsung launch CloudStream, tanpa perlu jalanin manual satu-satu:
#   sudo waydroid init
#   sudo systemctl start waydroid-container
#   waydroid session start
#   waydroid app launch com.lagradost.cloudstream3
#
# Tiap langkah dicek dulu statusnya — kalau sudah aktif, dilewati (jadi kalau
# semuanya udah nyala, jalanin ini nggak perlu sudo/password sama sekali).
#
# Pemakaian setelah terpasang:
#   waydroid-launcher              -> init (kalau perlu) + start + launch CloudStream
#   waydroid-launcher --ui         -> buka full Android UI, bukan CloudStream
#   waydroid-launcher --app <id>   -> launch app lain (application id)
#   waydroid-launcher --gapps      -> sertakan GAPPS saat init pertama kali
#   waydroid-launcher status       -> tampilkan 'waydroid status' apa adanya
#   waydroid-launcher stop         -> stop session + container
#
# Cara pasang (pilih salah satu):
#   environment.systemPackages = [ (pkgs.callPackage ./script-waydroid.nix { }) ];
#   home.packages               = [ (pkgs.callPackage ./script-waydroid.nix { }) ];
#   # atau sebagai flake app:
#   apps.default = { type = "app"; program = "${pkgs.callPackage ./script-waydroid.nix {}}/bin/waydroid-launcher"; };

{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "waydroid-launcher";

  runtimeInputs = with pkgs; [
    waydroid
    systemd
    gawk
    coreutils
  ];

  text = ''
    # --- Konfigurasi (edit sesuai kebutuhan) ---
    WAYDROID_CFG="/var/lib/waydroid/waydroid.cfg"
    DEFAULT_APP="com.lagradost.cloudstream3" # CloudStream
    CONTAINER_TIMEOUT=15
    SESSION_TIMEOUT=30
    SESSION_LOG="''${XDG_RUNTIME_DIR:-/tmp}/waydroid-launcher-session.log"

    log() { printf '\033[1;36m[waydroid-launcher]\033[0m %s\n' "$*"; }
    err() { printf '\033[1;31m[waydroid-launcher]\033[0m %s\n' "$*" >&2; }

    is_initialized() {
      [[ -f "$WAYDROID_CFG" ]]
    }

    container_state() {
      systemctl is-active waydroid-container 2>/dev/null || true
    }

    session_state() {
      local out
      out=$(waydroid status 2>/dev/null) || true
      echo "$out" | awk '/^Session:/ {print $2}'
    }

    wait_for_container() {
      local waited=0
      until [[ "$(container_state)" == "active" ]]; do
        if (( waited >= CONTAINER_TIMEOUT )); then
          err "Timeout menunggu waydroid-container aktif."
          return 1
        fi
        sleep 1
        waited=$((waited + 1))
      done
    }

    wait_for_session() {
      local waited=0
      until [[ "$(session_state)" == "RUNNING" ]]; do
        if (( waited >= SESSION_TIMEOUT )); then
          err "Timeout menunggu session RUNNING. Cek log: $SESSION_LOG"
          return 1
        fi
        sleep 1
        waited=$((waited + 1))
      done
    }

    ensure_initialized() {
      if is_initialized; then
        log "Sudah pernah di-init, skip 'waydroid init'."
        return
      fi
      log "Belum pernah init. Menjalankan 'waydroid init' (butuh sudo)..."
      if [[ "$USE_GAPPS" == "1" ]]; then
        sudo waydroid init -s GAPPS -f
      else
        sudo waydroid init
      fi
    }

    ensure_container() {
      if [[ "$(container_state)" == "active" ]]; then
        log "Container sudah aktif."
        return
      fi
      log "Menyalakan waydroid-container (butuh sudo)..."
      sudo systemctl start waydroid-container
      wait_for_container
      log "Container aktif."
    }

    ensure_session() {
      if [[ "$(session_state)" == "RUNNING" ]]; then
        log "Session sudah RUNNING."
        return
      fi
      log "Menjalankan waydroid session..."
      nohup waydroid session start >"$SESSION_LOG" 2>&1 &
      wait_for_session
      log "Session RUNNING."
    }

    launch_target() {
      local target="$1"
      if [[ "$target" == "ui" ]]; then
        log "Membuka full Android UI..."
        waydroid show-full-ui &
        disown
        return
      fi
      log "Launching $target..."
      waydroid app launch "$target" &
      disown
    }

    USE_GAPPS=0
    APP="$DEFAULT_APP"
    ACTION="launch"

    while [[ $# -gt 0 ]]; do
      case "$1" in
        stop)
          ACTION="stop"
          shift
          ;;
        status)
          ACTION="status"
          shift
          ;;
        --ui)
          APP="ui"
          shift
          ;;
        --app)
          if [[ $# -lt 2 ]]; then
            err "--app butuh argumen package id."
            exit 1
          fi
          APP="$2"
          shift 2
          ;;
        --gapps)
          USE_GAPPS=1
          shift
          ;;
        -h|--help)
          ACTION="help"
          shift
          ;;
        *)
          err "Argumen tidak dikenal: $1"
          exit 1
          ;;
      esac
    done

    case "$ACTION" in
      help)
        cat <<'USAGE'
Pemakaian: waydroid-launcher [stop|status] [--ui] [--app <package>] [--gapps]

  (tanpa argumen)   init (kalau belum pernah) -> start container -> start session -> launch CloudStream
  --ui              buka full Android UI, bukan langsung launch CloudStream
  --app <package>   launch app lain berdasarkan application id, mis. --app org.videolan.vlc
  --gapps           sertakan GAPPS saat init pertama kali (hanya berlaku kalau belum pernah init sama sekali)
  status            tampilkan output 'waydroid status' apa adanya
  stop              hentikan session dan container
USAGE
        ;;
      status)
        if ! is_initialized; then
          log "Waydroid belum pernah di-init."
          exit 0
        fi
        waydroid status
        ;;
      stop)
        log "Menghentikan session..."
        waydroid session stop 2>/dev/null || true
        if [[ "$(container_state)" == "active" ]]; then
          log "Menghentikan container (butuh sudo)..."
          sudo systemctl stop waydroid-container
        fi
        ;;
      launch)
        ensure_initialized
        ensure_container
        ensure_session
        launch_target "$APP"
        ;;
    esac
  '';
}
