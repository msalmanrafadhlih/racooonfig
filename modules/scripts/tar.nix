{ config, pkgs, lib, ... }:

{
  home.file.".local/bin/tar.sh" = {
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
		read -p "Masukkan path tujuan [default: /home/$USER/]: " DEST
		DEST="''${DEST/#\~/$HOME}"
		DEST="''${DEST:-/home/$USER/}"
		  
		# Buat folder tujuan kalau belum ada
		mkdir -p "$DEST"

		# Ekstrak
		echo "📦 Mengekstrak $TARFILE ke $DEST ..."
		tar -xvzf "$TARFILE" -C "$DEST"

		echo "✅ Selesai! File sudah diekstrak ke: $DEST"
    '';
    executable = true;
  };
}
