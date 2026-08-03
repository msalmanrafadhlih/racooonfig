# meta-sha.nix
{
  pkgs,
  config,
  lib,
  ...
}:

let
  rustSrc = pkgs.writeText "meta-sha-main.rs" ''
    use std::env;
    use std::fs;
    use std::process::exit;

    const TARGET_FILE: &str = "/etc/nixos/coreModules/openssh.nix";
    const URL_MARKER: &str = "https://api.github.com/meta";

    fn main() {
        let args: Vec<String> = env::args().collect();

        if args.len() < 2 || args[1] == "-h" || args[1] == "--help" {
            eprintln!("Pemakaian: meta-sha <sha256:xxxxx...>");
            eprintln!("Contoh   : meta-sha sha256:1a5c4fghm6lniprd0fsssxk8k06rjngikd3ia3i27n9mixffqbvq");
            exit(1);
        }

        let new_sha = args[1].trim();

        if !new_sha.starts_with("sha256:") {
            eprintln!("Error: hash harus diawali dengan 'sha256:'");
            exit(1);
        }

        let content = fs::read_to_string(TARGET_FILE).unwrap_or_else(|e| {
            eprintln!("Gagal membaca {}: {}", TARGET_FILE, e);
            exit(1);
        });

        let marker_pos = content.find(URL_MARKER).unwrap_or_else(|| {
            eprintln!("Tidak ditemukan url githubMeta ('{}') di dalam file", URL_MARKER);
            exit(1);
        });

        let search_area = &content[marker_pos..];
        let sha_key = "sha256 = \"";
        let sha_key_rel = search_area.find(sha_key).unwrap_or_else(|| {
            eprintln!("Tidak ditemukan field sha256 setelah url githubMeta");
            exit(1);
        });

        let sha_start = marker_pos + sha_key_rel + sha_key.len();
        let rest = &content[sha_start..];
        let sha_end_rel = rest.find('"').unwrap_or_else(|| {
            eprintln!("Format sha256 tidak valid (kutip penutup tidak ditemukan)");
            exit(1);
        });
        let sha_end = sha_start + sha_end_rel;
        let old_sha = &content[sha_start..sha_end];

        if old_sha == new_sha {
            println!("Sha sudah sama ({}), tidak ada perubahan.", old_sha);
            return;
        }

        let mut new_content = String::with_capacity(content.len());
        new_content.push_str(&content[..sha_start]);
        new_content.push_str(new_sha);
        new_content.push_str(&content[sha_end..]);

        fs::write(TARGET_FILE, new_content).unwrap_or_else(|e| {
            eprintln!("Gagal menulis {} (butuh sudo?): {}", TARGET_FILE, e);
            exit(1);
        });

        println!("Berhasil update sha256 githubMeta di {}", TARGET_FILE);
        println!("  lama : {}", old_sha);
        println!("  baru : {}", new_sha);
    }
  '';

 meta-hash = pkgs.stdenv.mkDerivation {
    name = "meta-sha";
    src = rustSrc;

    nativeBuildInputs = [
      pkgs.rustc
      pkgs.makeWrapper
    ];

    unpackPhase = "true"; # rustSrc sudah berupa file tunggal

    buildPhase = ''
      rustc -O ${rustSrc} -o meta-sha
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp meta-sha $out/bin/.meta-sha-unwrapped
      makeWrapper $out/bin/.meta-sha-unwrapped $out/bin/meta-sha
    '';
  };

in
{
  home.packages = [ meta-hash ];
}
