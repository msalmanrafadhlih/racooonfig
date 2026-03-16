{
 home.file.".local/bin/pandoc.sh" = {
   text = ''
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p pandoc

# Cek apakah argumen diberikan
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_cookies> <path_to_list_url>"
    exit 1
fi

# Menggunakan absolute path agar tidak bingung saat pindah direktori
COOKIE_PATH=$(realpath "$1")
URL_LIST_PATH=$(realpath "$2")
TEMP_DIR="temp_html_$(date +%s)"
OUTPUT_FILE="kursus_lengkap.epub"

# Verifikasi keberadaan file
if [ ! -f "$COOKIE_PATH" ]; then
    echo "Error: File cookies di '$COOKIE_PATH' tidak ditemukan!"
    exit 1
fi

if [ ! -f "$URL_LIST_PATH" ]; then
    echo "Error: File list-url di '$URL_LIST_PATH' tidak ditemukan!"
    exit 1
fi

# Buat folder sementara
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

echo "Mulai mengunduh materi (NixOS Compatible)..."

count=1
html_files=()

# Membaca list URL
while IFS= read -r url || [ -n "$url" ]; do
    [ -z "$url" ] && continue

    printf -v padded_count "%03d" $count
    temp_name="materi_''${padded_count}.html"

    echo "[$padded_count] Fetching: $url"

    # -L untuk handle redirect, -s untuk silent
    curl -s -L --cookie "$COOKIE_PATH" "$url" -o "$temp_name"

    html_files+=("$temp_name")
    count=$((count + 1))

    # Delay ramah server
    sleep 0.5
done < "$URL_LIST_PATH"

echo "------------------------------------------"
echo "Mengonversi ke EPUB menggunakan Pandoc..."

# Menggabungkan semua HTML menjadi satu EPUB
# --toc untuk daftar isi, --standalone untuk dokumen lengkap
pandoc "''${html_files[@]}" \
    -f html \
    -t epub \
    --toc \
    --toc-depth=2 \
    --metadata title="Fullstack Rust dan React - SantriKoding" \
    --metadata author="SantriKoding" \
    -o "../$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Berhasil! File tersimpan di: $OUTPUT_FILE"
    cd ..
    rm -rf "$TEMP_DIR"
else
    echo "Gagal saat proses konversi Pandoc."
    cd ..
fi
     '';
   executable = true;
 };
}
