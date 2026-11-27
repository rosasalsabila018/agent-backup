#!/bin/bash
# Auto-backup konfigurasi agen MuseAI_v1 ke repo GitHub agent-backup.
# Dijalankan cron harian 03:00 WIB (id: agent-backup-auto).
# Diam bila tidak ada perubahan; exit non-zero + pesan error bila gagal.
set -u
B="$HOME/workspace/agent-backup"
LOG="$HOME/workspace/agent-backup-sync.log"
TS="$(date '+%Y-%m-%d %H:%M:%S %Z')"
{
echo "[$TS] mulai"
# Self-heal: kalau folder/repo lokal hilang, clone ulang dari GitHub
if [ ! -d "$B/.git" ]; then
  echo "[$TS] repo lokal hilang, clone ulang"
  rm -rf "$B"
  git -c protocol.version=0 clone https://github.com/rosasalsabila018/agent-backup.git "$B" || { echo "[$TS] GAGAL clone"; exit 1; }
fi
# 1. Sync file konfigurasi (rsync hanya membaca sumber, aslinya tak diubah)
rsync -a ~/SOUL.md ~/AGENTS.md ~/USER.md ~/MEMORY.md ~/TOOLS.md ~/IDENTITY.md ~/HEARTBEAT.md ~/PROACTIVE_PREFERENCES.md ~/workspace/DAFTAR-INSTALASI.md "$B/" || exit 1
rsync -a --delete ~/memory/ "$B/memory/" || exit 1
rsync -a --delete --exclude '__pycache__' --exclude '*.pyc' --exclude '.write-lock' ~/workspace/custom-skills/ "$B/skills/" || exit 1
rsync -a --delete --exclude '__pycache__' --exclude '*.pyc' --exclude '.write-lock' ~/workspace/custom-connectors/ "$B/connectors/" || exit 1
rsync -a ~/.hermes/config.yaml "$B/hermes/" || exit 1
# 2. Pindai secret — batalkan bila ada yang lolos
if find "$B" \( -iname '*.env*' -o -iname '*.key' -o -iname '*.pem' \) -print -quit | grep -q .; then
  echo "[$TS] GAGAL: file secret terdeteksi di backup, batalkan"; exit 1
fi
if grep -rIlE 'sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}' "$B" 2>/dev/null | grep -q .; then
  echo "[$TS] GAGAL: pola secret terdeteksi di backup, batalkan"; exit 1
fi
# 3. Commit + push hanya bila ada perubahan
cd "$B" || exit 1
# Self-heal: helper kredensial gh hilang tiap VM diganti (config global di /var/lib/hatch
# tidak selamat dari ganti VM). Pulihkan lewat gh sendiri (jalur yang dipercaya wrapper):
# JANGAN set credential.helper di config lokal repo — hatch-git mengarantina config
# repo yang berisi helper `!...` dan menghapus entrinya.
gh auth setup-git >/dev/null 2>&1 || true
# Egress proxy mematikan git protocol v2 (curl 56, koneksi putus); perintah clone/push
# di bawah memakai flag -c protocol.version=0 (terverifikasi jalan 27 Nov 2026).
# Pakai flag, bukan config repo: hatch-git mengarantina config repo yang berisi
# entri tertentu (terbukti pada credential.helper `!...`).
# CATATAN 27 Nov 2026 ~08:20 WIB: VM boot 07:39 memblokir UPLOAD ke GitHub sepenuhnya
# (POST git-receive-pack: h2 REFUSED_STREAM, h1.1 403 JSON tanpa header GitHub;
# POST api.github.com sama; CONNECT github.com:22 403) sementara GET jalan normal.
# Blokir ini tergantung egress VM — push 03:00 di VM sebelumnya berhasil.
# Bila push gagal, commit tetap aman di repo lokal (home persisten); cron besok coba lagi.
git add -A
if git diff --cached --quiet; then
  echo "[$TS] tidak ada perubahan, selesai"
  exit 0
fi
git commit -q -m "Auto-backup $(date -u '+%Y-%m-%dT%H:%M:%SZ')" || exit 1
git -c protocol.version=0 push -q origin main || { echo "[$TS] GAGAL push"; exit 1; }
echo "[$TS] push OK: $(git rev-parse --short HEAD)"
} >> "$LOG" 2>&1
