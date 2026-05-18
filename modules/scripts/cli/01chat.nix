{ pkgs, ... }:

let
  # ──────────────────────────────────────────────
  # Source Rust dikompilasi langsung dengan rustc
  # (tanpa cargo, tanpa external crates)
  # Runtime tools (curl, jq, mdcat) tetap dipakai
  # dan di-inject ke PATH via makeWrapper.
  # ──────────────────────────────────────────────
  rustSrc = pkgs.writeText "ai-chat-main.rs" ''
    use std::fs;
    use std::io::{self, BufRead, Write};
    use std::path::Path;
    use std::process::{Command, Stdio};

    // ── ANSI Colors ──────────────────────────────
    const GREEN:  &str = "\x1b[1;32m";
    const BLUE:   &str = "\x1b[1;34m";
    const RED:    &str = "\x1b[1;31m";
    const CYAN:   &str = "\x1b[1;36m";
    const YELLOW: &str = "\x1b[1;33m";
    const GRAY:   &str = "\x1b[0;90m";
    const RESET:  &str = "\x1b[0m";

    // ── Helper: baca output jq ───────────────────
    fn jq_read(filter: &str, file: &str) -> String {
        Command::new("jq")
            .args(["-r", filter, file])
            .output()
            .map(|o| String::from_utf8_lossy(&o.stdout).trim().to_string())
            .unwrap_or_default()
    }

    // ── Helper: update JSON file via jq ─────────
    // extra_args  : misal &["--arg", "key", "val"]
    // filter      : jq filter string
    // file        : file yang dimodifikasi (atomic via .tmp)
    fn jq_write(extra_args: &[&str], filter: &str, file: &str) {
        let mut args: Vec<&str> = extra_args.to_vec();
        args.push(filter);
        args.push(file);

        let out = Command::new("jq")
            .args(&args)
            .output()
            .expect("[jq_write] jq gagal dijalankan");

        let tmp = format!("{}.tmp", file);
        fs::write(&tmp, &out.stdout).expect("[jq_write] gagal tulis .tmp");
        fs::rename(&tmp, file).expect("[jq_write] gagal rename .tmp -> file");
    }

    fn main() {
        // ── Konfigurasi ──────────────────────────
        let home = std::env::var("HOME").expect("$HOME tidak ditemukan");
        let api_key_path = format!("{}/.ssh/gemini.txt", home);

        if !Path::new(&api_key_path).exists() {
            eprintln!(
                "{}Error: File API Key tidak ditemukan di {}{}",
                RED, api_key_path, RESET
            );
            std::process::exit(1);
        }

        let api_key = fs::read_to_string(&api_key_path)
            .expect("Gagal membaca API key")
            .trim()
            .to_string();

        let model    = "gemini-2.5-flash";
        let endpoint = format!(
            "https://generativelanguage.googleapis.com/v1beta/models/{}:generateContent",
            model
        );
        let sys_prompt = "jawablah dengan ringkas tanpa bertele-tele";

        // ── Setup direktori & file ───────────────
        let cache_dir     = format!("{}/.gemini/tmp", home);
        let history_file  = format!("{}/chat_history.json", cache_dir);
        let payload_file  = format!("{}/payload.json", cache_dir);
        let response_file = format!("{}/response.json", cache_dir);

        fs::create_dir_all(&cache_dir).expect("Gagal membuat direktori cache");

        // Inisialisasi history jika belum ada / kosong
        let is_empty = fs::metadata(&history_file)
            .map(|m| m.len() == 0)
            .unwrap_or(true);
        if !Path::new(&history_file).exists() || is_empty {
            fs::write(&history_file, "[]").expect("Gagal inisialisasi history");
        }

        // ── Header ───────────────────────────────
        print!("\x1b[2J\x1b[1;1H"); // clear screen
        println!("{}=================================================={}", BLUE, RESET);
        println!("{}            🤖 Gemini AI - Mode Jutek{}", BLUE, RESET);
        println!("                        ---");
        println!(" Model: {}", model);
        println!("{}=================================================={}", BLUE, RESET);
        println!("                         Quit[q], Session[reset]");

        // ── Main loop ────────────────────────────
        let stdin = io::stdin();

        loop {
            print!("\n{}You:\n{}", GREEN, RESET);
            io::stdout().flush().unwrap();

            let mut line = String::new();
            // EOF (Ctrl+D) → keluar
            if stdin.lock().read_line(&mut line).unwrap_or(0) == 0 {
                println!("\n{}Sesi berakhir. Sampai jumpa!{}", RED, RESET);
                break;
            }
            let input = line.trim().to_string();

            match input.as_str() {
                "q" | "exit" => {
                    fs::remove_file(&payload_file).ok();
                    fs::remove_file(&response_file).ok();
                    println!("\n{}Sesi berakhir. Sampai jumpa!{}", RED, RESET);
                    break;
                }
                "reset" => {
                    fs::write(&history_file, "[]").expect("Gagal reset history");
                    println!("{}[!] Ingatan dihapus.", YELLOW);
                    println!(
                        "{} ────────────────────────────────────────────────{}",
                        GRAY, RESET
                    );
                    continue;
                }
                "" => continue,
                _  => {}
            }

            // 1. Tambah pesan user ke history
            jq_write(
                &["--arg", "txt", &input],
                ". += [{\"role\": \"user\", \"parts\": [{\"text\": $txt}]}]",
                &history_file,
            );

            // 2. Buat payload (sertakan system instruction)
            let payload_out = Command::new("jq")
                .args([
                    "--arg", "sys", sys_prompt,
                    "{systemInstruction: {parts: [{text: $sys}]}, contents: .}",
                    &history_file,
                ])
                .output()
                .expect("Gagal membuat payload");
            fs::write(&payload_file, &payload_out.stdout).expect("Gagal menulis payload");

            // 3. Tampilkan indikator loading
            print!("{}Gemini sedang berpikir...{}", CYAN, RESET);
            io::stdout().flush().unwrap();

            // 4. Kirim request via curl
            let resp = Command::new("curl")
                .args([
                    "-s", "-X", "POST", &endpoint,
                    "-H", "Content-Type: application/json",
                    "-H", &format!("x-goog-api-key: {}", api_key),
                    "-d", &format!("@{}", payload_file),
                ])
                .output()
                .expect("curl gagal dijalankan");
            fs::write(&response_file, &resp.stdout).expect("Gagal menulis response");

            // Hapus baris "sedang berpikir"
            print!("\r\x1b[K");
            io::stdout().flush().unwrap();

            // 5. Parse jawaban
            let answer = jq_read(
                ".candidates[0].content.parts[0].text // empty",
                &response_file,
            );

            if answer.is_empty() {
                // ── Error ────────────────────────
                let err = jq_read(
                    ".error.message // .candidates[0].finishReason // \"Unknown Error\"",
                    &response_file,
                );
                println!("{}[Error]: {}{}", RED, err, RESET);

                // Rollback: hapus pesan user dari history
                jq_write(&[], "del(.[-1])", &history_file);
            } else {
                // ── Sukses ───────────────────────
                println!("\n{}Gemini:{}", BLUE, RESET);

                // Render markdown via mdcat
                let mut mdcat = Command::new("mdcat")
                    .stdin(Stdio::piped())
                    .spawn()
                    .expect("mdcat gagal dijalankan");
                if let Some(mut pipe) = mdcat.stdin.take() {
                    pipe.write_all(answer.as_bytes()).ok();
                }
                mdcat.wait().ok();

                // Token usage
                let tp = jq_read(".usageMetadata.promptTokenCount // 0",     &response_file);
                let tr = jq_read(".usageMetadata.candidatesTokenCount // 0",  &response_file);
                let tt = jq_read(".usageMetadata.totalTokenCount // 0",       &response_file);

                println!(
                    "{}\n   📊 Token Usage: P: {} | R: {} | Total: {} {}",
                    YELLOW, tp, tr, tt, RESET
                );
                println!(
                    "{} ────────────────────────────────────────────────{}",
                    GRAY, RESET
                );

                // 6. Tambah respons model ke history
                jq_write(
                    &["--arg", "txt", &answer],
                    ". += [{\"role\": \"model\", \"parts\": [{\"text\": $txt}]}]",
                    &history_file,
                );
            }
        }
    }
  '';

  # ──────────────────────────────────────────────
  # Derivasi: compile rustSrc dengan rustc,
  # lalu wrap binary agar jq/curl/mdcat tersedia
  # di PATH saat runtime.
  # ──────────────────────────────────────────────
  ai-chat = pkgs.stdenv.mkDerivation {
    name = "ai-chat";
    src = rustSrc;

    nativeBuildInputs = [
      pkgs.rustc
      pkgs.makeWrapper
    ];

    unpackPhase = "true"; # rustSrc sudah berupa file tunggal

    buildPhase = ''
      rustc ${rustSrc} -o ai-chat
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ai-chat $out/bin/.ai-chat-unwrapped
      makeWrapper $out/bin/.ai-chat-unwrapped $out/bin/ai-chat \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.jq
            pkgs.curl
            pkgs.mdcat
          ]
        }
    '';
  };

in
{
  environment.systemPackages = [ ai-chat ];
}
