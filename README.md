# agent-backup

Backup konfigurasi agen MuseAI_v1 (Muse) milik Sayang.
Dibuat 20 Nov 2026 dari VM Muse (`/home/hatch`), disalin tanpa mengubah file asli.

Repo GitHub (private): https://github.com/rosasalsabila018/agent-backup

## Isi

| Path | Asal | Isi |
|---|---|---|
| `SOUL.md` | `~/SOUL.md` | Persona & tone agen |
| `AGENTS.md` | `~/AGENTS.md` | Manual operasi workspace + peran MEMORY-JANITOR |
| `USER.md` | `~/USER.md` | Profil Sayang |
| `MEMORY.md` | `~/MEMORY.md` | Memori jangka panjang (fakta, keputusan, riwayat) |
| `TOOLS.md` | `~/TOOLS.md` | Catatan alat & quirks lingkungan |
| `IDENTITY.md` | `~/IDENTITY.md` | Nama & identitas agen (MuseAI_v1) |
| `HEARTBEAT.md` | `~/HEARTBEAT.md` | Konfigurasi heartbeat |
| `PROACTIVE_PREFERENCES.md` | `~/PROACTIVE_PREFERENCES.md` | Preferensi pesan proaktif (jam 06:30–21:30 WIB) |
| `DAFTAR-INSTALASI.md` | `~/workspace/DAFTAR-INSTALASI.md` | Inventaris repo & skill yang terpasang |
| `memory/` | `~/memory/` | 9 file: log harian, bank memori, index orang & grup |
| `skills/` | `~/workspace/custom-skills/` | 10 custom skill (713 file saat backup, lihat bawah) |
| `connectors/` | `~/workspace/custom-connectors/` | Doc + helper connector Telegram Bot |
| `hermes/config.yaml` | `~/.hermes/config.yaml` | Konfigurasi gateway Hermes (model `muse` via 9Router) |
| `.gitignore` | — | Pengaman: pola file secret & runtime junk |

Total saat backup: **737 file, ~56 MB** (517 file teks, 219 file biner — sebagian besar gambar preview tema Hallmark & media demo Awwwards).

### Skill yang ikut (di `skills/`)

| Skill | Isi |
|---|---|
| `artex_pentest_operations` | Jalankan & pulihkan pentest ARTEX via Muse Bridge |
| `awwwards` | Rubrik juri Awwwards, 19 panduan, template + 12 demo |
| `banner-design` | Desain banner |
| `brand` | Brand identity |
| `design` | Logo, CIP, banner, ikon, foto sosial |
| `design-system` | Design system & token |
| `hallmark` | Anti-AI-slop design skill (50 tema, sloplint) |
| `slides` | Presentasi HTML + Chart.js |
| `ui-styling` | shadcn/ui + Tailwind |
| `ui-ux-pro-max` | 80 gaya UI, 194 palet, 74 font pairing, 130 panduan UX |

## Yang TIDAK ikut (sengaja)

- **Secret & kredensial** — tidak ada `.env`, `*.key`, `*.pem`, token, atau password di repo ini.
  Semua dipindai sebelum commit dan tidak ditemukan nilai secret apa pun (yang ada hanya
  hash SHA-256 file APK publik, hash integritas npm, dan ID fixture — bukan kredensial).
  `.gitignore` di repo ini memblokir pola secret bila suatu saat terselip.
- **`CLAUDE.md`** — file ini tidak ada di VM saat backup dibuat.
- **Cache/runtime junk** — `__pycache__/`, `*.pyc`, `.write-lock` dibuang saat penyalinan.

## Cara restore

> Restore menimpa file konfigurasi di home directory. Cadangkan dulu keadaan sekarang
> bila ragu. Secret TIDAK ikut ter-restore — lihat bagian bawah.

```sh
git clone https://github.com/rosasalsabila018/agent-backup.git
cd agent-backup

# File konfigurasi utama -> home directory
cp SOUL.md AGENTS.md USER.md MEMORY.md TOOLS.md IDENTITY.md HEARTBEAT.md PROACTIVE_PREFERENCES.md ~/

# Memori, skill, connector
cp -r memory/. ~/memory/
cp -r skills/. ~/workspace/custom-skills/
cp -r connectors/. ~/workspace/custom-connectors/

# Konfigurasi Hermes
mkdir -p ~/.hermes
cp hermes/config.yaml ~/.hermes/config.yaml
```

### Yang harus dipasang ulang secara terpisah (tidak ada di backup ini)

- **Kredensial & key** (semua permission 600, jangan pernah commit):
  - `~/.hermes/.env` — token bot Telegram + 9Router API key
  - `~/muse-bridge/user.key`, `worker.key`, `keys.json`, `9router-api.key`
  - `~/artex/.env`, `.admin-password.txt`, `.api-token.txt`, `.pgpass.txt`
  - `~/.ssh/` — kunci SSH
- **Service systemd** (`/etc/systemd/system/` tidak selamat dari ganti VM):
  buat ulang unit `muse-bridge`, `9router`, `hermes-gateway` dari
  `~/muse-bridge/start-*.sh`, lalu `systemctl daemon-reload && systemctl enable --now` ketiganya.
  ARTEX hanya dihidupkan bila Sayang perintahkan mulai lagi.
- **Database ARTEX** — restore dari backup `~/workspace/ARTEX/backups/artex-db-*.sql.gz`
  terakhir via `sudo -u postgres pg_dump` / `psql` (bukan `docker compose`).

## Catatan

- Backup ini snapshot 20 Nov 2026. File di VM terus berubah (memori harian, cron, skill baru);
  buat snapshot baru secara berkala bila mau tetap sinkron.
- Repo ini private. Jangan jadikan publik — `MEMORY.md` berisi detail pribadi & riwayat kerja.
