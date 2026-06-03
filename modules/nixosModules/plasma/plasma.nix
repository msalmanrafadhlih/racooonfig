{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.enable && builtins.elem "plasma" cfg.desktopManager) {
    services.displayManager.sddm.wayland.enable = config.services.displayManager.sddm.enable;

    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
      # Agar app Qt5 lama (seperti VirtualBox GUI)
      # ikut tema Breeze, tidak tampil aneh
    };

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [

        # ── Aplikasi yang biasanya diganti dengan pilihan sendiri ───
        # Music player bawaan KDE
        elisa
        # → ganti dengan: pkgs.strawberry / pkgs.rhythmbox

        # ── Hemat storage ──────────────────────────────────────────
        plasma-workspace-wallpapers
        # Koleksi 30+ wallpaper ekstra (~100 MB)
        # Wallpaper default Breeze tetap ada

        # ── Jarang dipakai pengguna baru ───────────────────────────
        khelpcenter # Dokumentasi offline KDE (ada di internet)
        krdp # Server Remote Desktop (KDE ≥ 6.1)
        kate # text editor
        # aurorae # Engine tema dekorasi window kustom

        # ── Fitur Dolphin (bisa aktifkan nanti jika dibutuhkan) ────
        # dolphin-plugins # Plugin Git & Dropbox di sidebar Dolphin
        # baloo-widgets # Panel metadata file di Dolphin
        # ffmpegthumbs # Thumbnail pratinjau video di Dolphin
      ];
    };

    # ──────────────────────────────────────────────────────────────
    # NONAKTIFKAN SERVICE YANG AUTO-AKTIF TAPI TIDAK DIBUTUHKAN
    # ──────────────────────────────────────────────────────────────

    # KDE PIM — suite email KDE (KMail, Kontact, Akonadi daemon)
    # Ini bloat besar jika kamu tidak pakai KMail. Daemon Akonadi-nya
    # bisa makan RAM dan berjalan di background tanpa disadari.
    programs.kde-pim.enable = false;

    # Screen reader Orca — untuk aksesibilitas, nonaktifkan jika tidak perlu
    services.orca.enable = false;

    # ──────────────────────────────────────────────────────────────
    # KDE CONNECT — Sinkronisasi HP & PC
    # (kirim file, clipboard, notifikasi, remote input, dsb)
    # Module ini juga otomatis membuka port firewall yang dibutuhkan.
    # ──────────────────────────────────────────────────────────────

    programs.kdeconnect.enable = true;

    # Alat manajemen daya (power balanced)
    services.tlp.enable = lib.mkForce false;
    services.power-profiles-daemon.enable = true;

    # ──────────────────────────────────────────────────────────────
    # CATATAN: Apa yang SUDAH OTOMATIS aktif oleh Plasma 6
    # (tidak perlu kamu tulis ulang):
    #
    #   ✓ services.pipewire.enable       (audio)
    #   ✓ services.udisks2.enable        (auto-mount USB/disk)
    #   ✓ services.libinput.enable       (touchpad/mouse)
    #   ✓ services.power-profiles-daemon (profil daya baterai)
    #   ✓ services.geoclue2.enable       (timezone otomatis)
    #   ✓ services.fwupd.enable          (update firmware)
    #   ✓ xdg.portal.enable              (file picker, screenshot API)
    #   ✓ security.polkit               (otorisasi operasi sistem)
    #   ✓ programs.partition-manager    (KDE Partition Manager)
    #   ✓ programs.dconf.enable         (GTK settings backend)
    #
    # Serta paket-paket ini sudah ikut tanpa kamu minta:
    #   ✓ gwenview   (image viewer)
    #   ✓ konsole    (terminal)
    #   ✓ dolphin    (filemanager)
    #   ✓ okular     (PDF/document viewer)
    #   ✓ ark        (archive manager)
    #   ✓ spectacle  (screenshot tool)
    #   ✓ systemsettings (panel pengaturan)
    # ──────────────────────────────────────────────────────────────
  };
}
