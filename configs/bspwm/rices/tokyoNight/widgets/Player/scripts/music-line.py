#music-line.py

import os
import subprocess
import datetime

# Gunakan expanduser untuk mendapatkan path home yang aman
home = os.path.expanduser("~")
desktop = os.getenv("XDG_CURRENT_DESKTOP", "default_desktop")

# Gunakan 'with open' agar file otomatis ditutup
with open(f"{home}/.config/{desktop}/.rice", "r") as f:
    RICE = f.readline().strip()

def lrcdl():
    try:
        # Perbaikan RICE() menjadi RICE
        script_path = f"{home}/.config/{desktop}/rices/{RICE}/widgets/Player/scripts/lyrics.py"
        subprocess.run(["python", script_path])
    except Exception as e:
        print(f"Gagal download lirik: {e}")

source = "spotify"

# Gunakan text=True dan .strip() untuk mendapatkan teks bersih
def get_playerctl(command):
    res = subprocess.run(["playerctl"] + command + ["-p", source], capture_output=True, text=True)
    return res.stdout.strip()

title = get_playerctl(["metadata", "title"])
artist = get_playerctl(["metadata", "artist"])
position = get_playerctl(["position"])

# Jika lagu tidak ada/berhenti, matikan script
if not position:
    exit()

lrc_path = f"{home}/Music/lyrics/{artist} - {title}.lrc"

# Panggil fungsi download jika lirik tidak ada
if not os.path.exists(lrc_path):
    lrcdl()
    exit()

cur_base = str(datetime.timedelta(seconds=(float(position.split('.')[0])))).split(':')
cur_minutes = cur_base[1]
cur_seconds = cur_base[2]

with open(lrc_path, "r") as f:
    lines = f.readlines()

cache_path = f"{home}/.cache/line.txt"
now = ""

# Pastikan file cache ada sebelum dibaca
if os.path.exists(cache_path):
    with open(cache_path, "r") as f:
        content = f.readlines()
        if content:
            now = content[0]

for line in lines:
    if len(line) < 10: 
        continue # Lewati baris kosong atau tidak valid
        
    # Memisahkan waktu dan lirik dengan aman
    parts = line.split("]", 1)
    if len(parts) < 2:
        continue
        
    lrc_time = parts[0] # [mm:ss.xx
    words = parts[1]
    
    lrc_minutes = lrc_time[1:3]
    lrc_seconds = lrc_time[4:6]
    
    if lrc_minutes == cur_minutes and lrc_seconds == cur_seconds and now != words:
        with open(cache_path, "w") as f:
            if not words.strip(): 
                words = "No lyrics found!\n"
            f.write(words)
        exit()
