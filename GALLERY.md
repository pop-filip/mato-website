# Gallery System — matografie.at

**Implementirano:** 2026-05-06  
**Status:** LIVE ✅  
**URL:** `https://matografie.at/gallery`

---

## Pregled

Automatski gallery sistem koji sinkronizira sadržaj s Nextcloud instance (`cloud.digitalnature.at`) na website. Klijent (Mato) uploaduje fotografije i videe u Nextcloud folder → svakih 15 minuta se automatski pojavljuju na sajtu, bez ikakve intervencije developera.

---

## Kompletan Flow

```
Mato uploaduje fajl na Nextcloud
        │
        ▼
cloud.digitalnature.at → matografie/ folder
        │
        ▼ (cron svakih 15 min)
sync-gallery.sh na serveru
        │
        ├── rclone sync (slike → gallery/)
        ├── rclone sync (videi → gallery/originals/)
        ├── ffmpeg konverzija (originals/ → gallery/, web-optimizovano)
        ├── ffmpeg thumbnail (gallery/thumbs/)
        └── regeneracija gallery/index.json
        │
        ▼
matografie.at/gallery (gallery.html čita index.json via JS)
```

---

## Nextcloud Setup

**Remote:** `nextcloud` (rclone alias)  
**WebDAV URL:** `https://cloud.digitalnature.at/remote.php/dav/files/mato/`  
**Folder:** `matografie/` (root, bez podfoldera)  
**Korisnik:** `mato`  
**Config:** `/root/.config/rclone/rclone.conf` na serveru

### Šta Mato uploaduje

- **Slike:** `.jpg`, `.jpeg`, `.png`, `.webp`, `.gif`, `.avif` — idu direktno na gallery
- **Videi:** `.mp4`, `.mov`, `.webm` — prolaze kroz ffmpeg konverziju

---

## Konvencija naziva fajlova (videi)

Videi moraju biti nazvani po ovom formatu da dobiju metadata:

```
YYYY - Naziv projekta - Kratak opis.mp4
```

**Primjeri:**
```
2026 - Weddings - Wedding highlight film Croatia.mp4
2024 - Events - Asia Luna Festival in Linzer Solar-City.mp4
2025 - Music Video - Linzer Brücke.mp4
```

Sync script automatski parsira:
- `year` → 2026
- `title` → Weddings
- `description` → Wedding highlight film Croatia

Fajlovi bez ovog formata se prikazuju bez metapodataka (samo thumbnail + play button).

---

## Server Setup

**Server:** Hetzner VPS `157.180.67.68`  
**Web root:** `/var/www/mato-website/html/`  
**Gallery dir:** `/var/www/mato-website/html/gallery/`

### Struktura na serveru

```
/var/www/mato-website/html/
├── gallery.html                  ← Gallery stranica
└── gallery/
    ├── index.json                ← Auto-generiran manifest (ne editovati!)
    ├── meta.json                 ← Rezerva za ručne override (opcionalno)
    ├── originals/                ← Originali s Nextclouda (ne serviraju se)
    │   ├── 2026 - Weddings - ....mp4
    │   └── ...
    ├── thumbs/                   ← Auto-generirani thumbnails
    │   ├── 2026 - Weddings -..._thumb.jpg
    │   └── ...
    ├── 2026 - Weddings - ....mp4 ← Web-optimizovani (ffmpeg output)
    ├── Matografie.at 10.jpg
    └── ...
```

### Instalirani alati

| Alat | Verzija | Svrha |
|------|---------|-------|
| rclone | v1.74.0 | Sync s Nextclouda |
| ffmpeg | sistem | Video konverzija + thumbnails |

### Cron job

```bash
# /root/crontab — svakih 15 minuta
*/15 * * * * /usr/local/bin/sync-gallery.sh >> /var/log/gallery-sync.log 2>&1
```

---

## Sync Script

**Lokacija na serveru:** `/usr/local/bin/sync-gallery.sh`  
**Git lokacija:** `sync-gallery.sh` (u root repoa)  
**Log:** `/var/log/gallery-sync.log`

### Koraci koje script radi

1. **rclone sync slike** — `nextcloud:matografie/` → `gallery/` (samo image extenzije, max-depth 1 za podfolderima)
2. **rclone sync videi** — `nextcloud:matografie/` → `gallery/originals/` (samo video extenzije)
3. **ffmpeg konverzija** — za svaki novi video u `originals/` koji još ne postoji u `gallery/`:
   - `libx264`, CRF 26, preset medium
   - Scale max 1920px wide
   - AAC 128kbps audio
   - `-movflags +faststart` (web streaming optimizacija)
4. **ffmpeg thumbnails** — za svaki novi video u `gallery/` generiše `thumbs/naziv_thumb.jpg`
5. **Regeneracija `index.json`** — skenira `gallery/`, parsira filenames, kreira manifest

### Deploy update skripte

```bash
scp sync-gallery.sh root@157.180.67.68:/usr/local/bin/sync-gallery.sh
```

---

## ffmpeg Konverzija — Rezultati

Primjer kompresije (CRF 26, preset medium):

| Fajl | Original | Konvertovano | Uštedina |
|------|----------|--------------|----------|
| Music Video (Linzer Brücke) | 48 MB | 18 MB | -62% |
| DTF1Video | 230 MB | u toku | — |
| Delta Team Frauen 2 | 159 MB | u toku | — |
| Weddings (Croatia) | 154 MB | u toku | — |

---

## gallery.html

**Standalone stranica** — nije dio index.html SPA.

### Funkcionalnosti

- **Filter tabovi:** Photos / Videos
- **CSS masonry grid:** 3 kolone (desktop) → 2 (tablet) → 1 (mob)
- **Lazy loading** svih slika
- **Lightbox:** slike (fullscreen zoom) + videi (autoplay, controls)
- **Keyboard navigacija:** ESC (zatvori), ← → (navigacija)
- **Video metadata:** godina, naziv, opis — prikazano ispod kartice i u lightboxu
- **EN/DE switcher** — konzistentan s glavnim sajtom
- **Hamburger meni** s video pozadinom — identičan glavnom sajtu
- **Sticky filter bar** — prati scroll
- **Empty state** — elegantna poruka ako nema sadržaja
- **Loading state** — animirani dots dok se index.json učitava

### Kako čita sadržaj

```javascript
fetch('gallery/index.json?v=' + Date.now())
```

Cache-busting s timestampom — uvijek svježa verzija.

### index.json format

```json
{
  "updated": "2026-05-07T10:00:00Z",
  "items": [
    {
      "type": "image",
      "file": "Matografie.at 10.jpg",
      "date": "2026-04-09T21:53:00Z"
    },
    {
      "type": "video",
      "file": "2026 - Weddings - Wedding highlight film Croatia.mp4",
      "thumb": "thumbs/2026 - Weddings - Wedding highlight film Croatia_thumb.jpg",
      "year": "2026",
      "title": "Weddings",
      "description": "Wedding highlight film Croatia",
      "date": "2026-04-18T00:00:00Z"
    }
  ]
}
```

---

## nginx Config

Dodan redirect u `/var/www/mato-website/nginx.conf`:

```nginx
location = /gallery { return 301 /gallery.html; }
location = /gallery/ { return 301 /gallery.html; }
```

Razlog: SPA `try_files $uri $uri/ /index.html` bi servirao `gallery/` direktorij → 403.

---

## Kako dodati novi sadržaj

### Slike
1. Uploaduj `.jpg`/`.png`/`.webp` u `matografie/` na Nextcloudu
2. Čekaj max 15 minuta → automatski se pojavljuje u Photos tabu

### Videi
1. Preimenuj fajl u format: `YYYY - Naziv - Kratak opis.mp4`
2. Uploaduj u `matografie/` na Nextcloudu
3. Čekaj konverziju (ovisno o veličini: 5-30 minuta)
4. Pojavljuje se u Videos tabu s metapodacima

### Ručni resync (ako treba odmah)
```bash
ssh root@157.180.67.68 "bash /usr/local/bin/sync-gallery.sh"
```

---

## Praćenje

```bash
# Live log
ssh root@157.180.67.68 "tail -f /var/log/gallery-sync.log"

# Šta je u galleryu
ssh root@157.180.67.68 "ls /var/www/mato-website/html/gallery/"

# Provjeri index.json
ssh root@157.180.67.68 "python3 -c \"import json; d=json.load(open('/var/www/mato-website/html/gallery/index.json')); print('Items:', len(d['items']))\""
```

---

## Planirano (sljedeća faza)

### Projekt-bazirana gallery struktura

Umjesto flat galerije, organizacija po projektima:

```
matografie/
├── Delta Team/
│   ├── fotos/
│   └── 2026 - Delta Team - Event highlights.mp4
├── Jasko Official/
│   ├── fotos/  
│   └── 2026 - Jasko - Full production music video.mp4
└── Weddings/
    └── 2026 - Weddings - Croatia.mp4
```

Gallery prikazuje projekte kao kartice → klik otvara projekt s Photos/Videos tabovima.

**"Full Production" badge** — posebno označeni projekti (Jasko, Delta Team) s gold tagom.

Zahtijeva: novi format index.json, redesign gallery.html, rclone bez `--max-depth 1`.

---

## Git Commits (ova implementacija)

| Hash | Opis |
|------|------|
| `be4b6e5` | feat: gallery stranica s Nextcloud auto-sync |
| `1083959` | gallery: ukloni All filter, default Photos |
| `bf2a698` | gallery: video metadata (title, year) + meta.json sistem |
| `50c95cc` | gallery: filename parsing YYYY - Title - Description |
| `b504ebb` | gallery: video info ispod kartice (godina, naziv, opis) |
| `9b4773e` | nav: dodaj Gallery link u desktop i mobilni meni |
