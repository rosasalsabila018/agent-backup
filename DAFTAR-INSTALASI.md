# Daftar Instalasi MuseAI_v1

Disusun 20 Nov 2026 ~08:05 WIB, atas permintaan Sayang 20 Nov 2026 ~01:32 WIB
("Apa yang kepasang dikamu lalu kamu kirim github repo ya kumpulannya soalnya
tadi banyak saya lupa"). Diverifikasi langsung dari workspace dan git remote.
Diperbarui 20 Nov 2026 ~12:03 WIB: tambah awwwards-skill + repo agent-backup.

## Repo GitHub (7)

| # | Repo | Lokasi lokal | Keterangan |
|---|---|---|---|
| 1 | [Kutuyyy/Muse-on-9Router-Hermes-Agent-ai](https://github.com/Kutuyyy/Muse-on-9Router-Hermes-Agent-ai) | `~/workspace/Muse-on-9Router-Hermes-Agent-ai/` | Jembatan ke Telegram: bot @K0d0k_bot, 9Router, bridge — aktif |
| 2 | [Kutuyyy/MEMORY-JANITOR-prompt-Muse-AI](https://github.com/Kutuyyy/MEMORY-JANITOR-prompt-Muse-AI) | `~/workspace/MEMORY-JANITOR-prompt-Muse-AI/` | Diagnostik & bersih-bersih RAM VM; cron autorun tiap 10 menit, hanya kabari bila available tetap < 512 MB |
| 3 | [BaaRai/ARTEX](https://github.com/BaaRai/ARTEX) | `~/workspace/ARTEX/` | Platform pentest autonomous v0.6.0, dipakai buat pentest nadiavpn.web.id — **DIMATIKAN sesuai perintah Sayang 19 Nov 2026 15:34 WIB, sampai diperintah mulai lagi** |
| 4 | [morluto/rea](https://github.com/morluto/rea) | `~/workspace/rea/` | REA (Reverse Engineer Anything) v6.9.0, MCP server + CLI; terdaftar di Hermes, 262 tool aktif |
| 5 | [nutlope/hallmark](https://github.com/nutlope/hallmark) | `~/workspace/hallmark/` | Skill desain anti-"AI slop", 50 tema + alat lint `sloplint`; terpasang 20 Nov 2026 01:00 WIB |
| 6 | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | `~/workspace/ui-ux-pro-max-skill/` | Paket 7 skill desain (ui-ux-pro-max, ui-styling, design, design-system, brand, slides, banner-design); terpasang 20 Nov 2026 01:10 WIB |
| 7 | [SandroHub013/awwwards-skill](https://github.com/SandroHub013/awwwards-skill) | `~/workspace/awwwards-skill/` | Skill desain level Awwwards v1.9.0 (102 MB): rubrik juri, metode build 8 fase, 19 panduan referensi, template starter + webgl-hero, 12 demo; test struktur lolos 74/74; terpasang 20 Nov 2026 09:01 WIB |

## Repo GitHub lain (bukan instalasi skill, tapi dibuat dari Muse)

- [rosasalsabila018/agent-backup](https://github.com/rosasalsabila018/agent-backup) (private) — backup konfigurasi agen: 737 file, ~56 MB, commit 58947c0, dibuat 20 Nov 2026 ~09:15 WIB; backup otomatis tiap hari 03:00 WIB (cron `agent-backup-auto`, skrip `~/workspace/agent-backup/backup.sh`, diam bila tidak ada perubahan). Isi: 9 file konfigurasi utama, `memory/`, 10 custom skill, konektor Telegram, `hermes/config.yaml`, README + .gitignore; tanpa secret.

## Akses GitHub

- Terhubung 20 Nov 2026 ~09:04 WIB atas nama akun **rosasalsabila018**, instalasi GitHub App "All repo": 5 repo bisa diakses (VolBubble, TnError-Slow, SumutTunnel — ketiganya private — plus stserver dan G). Repo-repo akun Kutuyyy (Muse Bridge, MEMORY-JANITOR, dll.) TIDAK tercakup — perlu instalasi terpisah di akun Kutuyyy.

## Skill custom lain (bukan dari GitHub)

- **artex_pentest_operations** — `~/workspace/custom-skills/artex_pentest_operations/` — skill buatan sendiri buat menjalankan & memulihkan pentest ARTEX lewat Bridge, termasuk workaround satu tool call per jawaban.
- 9 skill desain dari Hallmark, UI UX Pro Max & Awwwards (lihat tabel di atas): hallmark, ui-ux-pro-max, ui-styling, design, design-system, brand, slides, banner-design, awwwards.
- Total custom skill sekarang **10** (9 di atas + artex_pentest_operations).

## Konektor custom

- **custom.telegram-bot** — konektor bot Telegram custom.

## Folder laporan analisis (bukan instalasi, cuma hasil bedah)

- `~/workspace/mobiletool/` — analisis APK Mobile Tool / CEIRku
- `~/workspace/ceirku/` — bedah ceirku.org + `PERBANDINGAN.md` (perbandingan provider IMEI + sketsa backend)
- `~/workspace/hc-decrypt/` — script decrypt `.hc` TnError + analisis HTTP Custom
- `~/workspace/xnxx/` — analisis APK XNXX STABLE 1.63

Terakhir diperbarui: 20 Nov 2026 ~12:03 WIB. Kalau ada instalasi baru, daftar ini
perlu di-update lagi. File ini ikut ter-backup otomatis ke repo agent-backup
tiap hari 03:00 WIB, jadi salinannya juga aman di GitHub.
