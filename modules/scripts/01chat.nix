{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ###################################################
    ###########    SESSION MANAGER    ################# 
    (writeShellScriptBin "ai-chat" ''
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl mdcat

# 1. KONFIGURASI & PATH
API_KEY_FILE="$HOME/.ssh/gemini.txt"

if [ ! -f "$API_KEY_FILE" ]; then
    echo "Error: File API Key tidak ditemukan di $API_KEY_FILE"
    exit 1
fi

API_KEY=$(cat "$API_KEY_FILE")
MODEL_NAME="gemini-2.5-flash"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/$MODEL_NAME:generateContent"

# 2. KEPRIBADIAN (SYSTEM INSTRUCTION)
# Di sinilah roh "cewek jutek PMS" ditanamkan
SYSTEM_PROMPT="jawablah dengan ringkas tanpa bertele-tele"

# 3. WARNA
GREEN=$'\e[1;32m'
BLUE=$'\e[1;34m'
RED=$'\e[1;31m'
CYAN=$'\e[1;36m'
YELLOW=$'\e[1;33m'
GRAY=$'\e[0;90m'
RESET=$'\e[0m'

# 4. SETUP DIREKTORI & FILE
CACHE_DIR="$HOME/.gemini/tmp"
mkdir -p "$CACHE_DIR"

HISTORY_FILE="$CACHE_DIR/chat_history.json"
PAYLOAD_FILE="$CACHE_DIR/payload.json"
RESPONSE_FILE="$CACHE_DIR/response.json"

if [ ! -f "$HISTORY_FILE" ] || [ ! -s "$HISTORY_FILE" ]; then
    echo "[]" > "$HISTORY_FILE"
fi

cleanup() {
    echo -e "\n''${RED}Sesi berakhir. Sampai jumpa!''${RESET}"
    rm -f "$PAYLOAD_FILE" "$RESPONSE_FILE"
    exit
}

trap cleanup SIGINT

clear
echo "''${BLUE}==================================================''${RESET}"
echo "''${BLUE}            🤖 Gemini AI - Mode Jutek ''${RESET}"
echo "                        ---"
echo " Model: $MODEL_NAME"
echo "''${BLUE}==================================================''${RESET}"
echo "                         Quit[q], Session[reset]"

while true; do
    echo -e "\n''${GREEN}You:\n"
    read -r user_input

    if [[ "$user_input" == "exit" || "$user_input" == "q" ]]; then cleanup; fi
    if [[ "$user_input" == "reset" ]]; then
        echo "[]" > "$HISTORY_FILE"
        echo -e "''${YELLOW}[!] Ingatan dihapus.\n"
        echo "''${GRAY} ────────────────────────────────────────────────''${RESET}"
        continue
    fi
    if [[ -z "$user_input" ]]; then continue; fi

    # 1. Update History & Payload
    jq --arg txt "$user_input" '. += [{"role": "user", "parts": [{"text": $txt}]}]' "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

    # Memasukkan SYSTEM_PROMPT ke dalam struktur JSON
    jq --arg sys "$SYSTEM_PROMPT" '{systemInstruction: {parts: [{text: $sys}]}, contents: .}' "$HISTORY_FILE" > "$PAYLOAD_FILE"

    printf "''${CYAN}Gemini sedang berpikir...''${RESET}"

    # 2. Kirim Request
    curl -s -X POST "$ENDPOINT" \
        -H "Content-Type: application/json" \
        -H "x-goog-api-key: $API_KEY" \
        -d @"$PAYLOAD_FILE" > "$RESPONSE_FILE"

    # Hapus baris "sedang berpikir"
    printf "\r\033[K"

    # 3. Ambil Jawaban & TOKEN
    answer=$(jq -r '.candidates[0].content.parts[0].text // empty' "$RESPONSE_FILE")

    token_prompt=$(jq -r '.usageMetadata.promptTokenCount // 0' "$RESPONSE_FILE")
    token_resp=$(jq -r '.usageMetadata.candidatesTokenCount // 0' "$RESPONSE_FILE")
    token_total=$(jq -r '.usageMetadata.totalTokenCount // 0' "$RESPONSE_FILE")

    if [[ -z "$answer" ]]; then
        error_msg=$(jq -r '.error.message // .candidates[0].finishReason // "Unknown Error"' "$RESPONSE_FILE")
        echo "''${RED}[Error]: $error_msg''${RESET}"
        jq 'del(.[-1])' "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    else
        echo -e "\n''${BLUE}Gemini:''${RESET}"
        # echo "$answer" | glow -s dark -
        echo "$answer" | mdcat

        echo -e "''${YELLOW}\n   📊 Token Usage: P: $token_prompt | R: $token_resp | Total: $token_total ''${RESET}"
        echo "''${GRAY} ────────────────────────────────────────────────''${RESET}"

        jq --arg txt "$answer" '. += [{"role": "model", "parts": [{"text": $txt}]}]' "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    fi
done
      '')
  ];
}
