{ config, lib, ... }:
{
  config = lib.mkIf config.racooonfig.homeManager {
    home.file.".local/bin/targz" = {
      text = ''
        		#!/usr/bin/env bash
        		# tar - simple tar.gz installer for cursor/icon themes

        		# Tanya path file tar.gz
        		read -p "Masukkan path ke file .tar.gz: " TARFILE
        		TARFILE="''${TARFILE/#\~/$HOME}"

        		# cek apakah file ada
        		if [ ! -f "$TARFILE" ]; then
        		  echo "❌ File tidak ditemukan: $TARFILE"
        		  exit 1
        		fi

        		# Tanya tujuan (default /home/$USER/)
        		read -p "Masukkan path tujuan [default: /home/$USER/Documents]: " DEST
        		DEST="''${DEST/#\~/$HOME/Documents}"
        		DEST="''${DEST:-/home/$USER/Documents}"
        		  
        		# Buat folder tujuan kalau belum ada
        		mkdir -p "$DEST"

        		# Ekstrak
        		echo "📦 Mengekstrak $TARFILE ke $DEST ..."
        		tar -xvzf "$TARFILE" -C "$DEST"

        		echo "✅ Selesai! File sudah diekstrak ke: $DEST"
      '';
      executable = true;
    };
  };
}
