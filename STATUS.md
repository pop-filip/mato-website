# Status — Mato Davidović

Klijent:    Mato Davidović
Domena:     matografie.at
Kontakt:    —
Faza:       LIVE
Deadline:   —

## Server

- Server:     Hetzner VPS — 157.180.67.68
- Container:  `mato-website` (nginx:alpine, Docker)
- Web root:   `/var/www/mato-website/html/`
- Traefik:    route `matografie` → `matografie-svc` → `http://mato-website:80`
- SSL:        Let's Encrypt (auto, Traefik certResolver)
- Deploy:     rsync → `/var/www/mato-website/html/`

## Čeka se

- [ ] GitHub Actions Secrets (VPS_HOST, VPS_USER, VPS_SSH_KEY) — issue #13
- [ ] Google Search Console verifikacija + sitemap submit — issue #11
- [ ] GA4 Measurement ID + aktivacija — issue #15
- [ ] og-image.jpg — prava fotografija (1200×630) — issue #9
- [ ] Social media linkovi (kad se kreiraju profili) — issue #10

## Log

| Datum | Faza | Napomena |
|-------|------|----------|
| 2026-03-30 | DEVELOPMENT | Projekt kreiran |
| 2026-03-31 | DEPLOY_READY | Spreman za go live |
| 2026-04-09 | LIVE | Deploy na Hetzner VPS, DNS propagiran, SSL aktivan |
| 2026-04-11 | OPTIMIZACIJA | Perf + security audit, optimizacije deployane |

## Perf optimizacije (2026-04-11)

### Urađeno
- Inline CSS (1724 linije) → eksterni `style.css` (browser caching)
- `fetchpriority="high"` na logo.webp img tagu
- `dns-prefetch` za YouTube + ytimg
- `defer` na YouTube iframe_api scripti
- Video `preload="auto"` → `preload="metadata"` na heroVideo, aboutVideo, work-bg-video
- Uklonjen `<link rel="preload">` za 18MB video koji se nije koristio u video tagu

### Lighthouse score (2026-04-11)
- Mobile: 89 lokalni / ~63 PageSpeed (throttled)
- Desktop: 74 lokalni / ~59 PageSpeed (throttled)
- Accessibility: 93-99 ✅ | Best Practices: 92 ✅ | SEO: 92 ✅

### Zašto ne može više
- 3x autoplay video = ~20MB payload, neizbježno za video portfolio
- Kompresija testirana (480p/CRF35), vizualni kvalitet neprihvatljiv
- 59-63 PageSpeed je realni strop za ovaj tip sajta

### Ostaje otvoreno
- CSS minifikacija (`style.css` 1722 linije) → +2-3 poena
- YouTube facade → +5-8 poena
- Google Fonts async load → potencijalno +10 mobilni

## Email (2026-04-12)

Provider: **forwardemail.net** (besplatni tier)
DNS panel: **World4You** (matografie.at)

### DNS Records

| Type | Name | Value |
|------|------|-------|
| MX | @ | `mx1.forwardemail.net` (priority 10) |
| MX | @ | `mx2.forwardemail.net` (priority 20) |
| TXT | @ | `forward-email=info:popovic.f@protonmail.com` |
| TXT | @ | `v=spf1 a mx include:spf.forwardemail.net -all` |
| TXT | `_dmarc` | `v=DMARC1; p=none; pct=100; rua=mailto:info@matografie.at` |

### Forwarding mapa

| Inbox | Proslijeđuje na |
|-------|-----------------|
| info@matografie.at | popovic.f@protonmail.com |

### Napomene
- `info@matografie.at` ubačen na sajt (contact sekcija + footer + Schema.org JSON-LD)
- Zamijenio stari `info@mato-production.com` na svim mjestima (5 occurrences)
- SPF i DMARC obavezni — bez njih Proton odbija ili stavlja u spam

## Mobile (2026-04-12)

### Arhitektura
- `mobile-preview.html` — lokalni preview fajl (iPhone 14 shell, 390×844), učitava `index.html` u iframe
- Service Worker (`sw.js`) — cache-first za statiku, network-first za navigaciju (HTML uvijek svjež)
- SW cache verzija: `matografie-v2` (bumped 2026-04-12)

### Deploy napomena
- `index.html` i `sw.js` moraju biti deployani zajedno kad se mijenja sadržaj
- Kad SW promijeni CACHE_NAME verziju → telefon automatski briše stari cache i povlači novi HTML
- Bez bump verzije → telefon servira stari HTML iz cache-a čak i nakon rsynca

### Urađeno
- `info@mato-production.com` → `info@matografie.at` (index.html, deployano 2026-04-12)
- SW cache bump v1 → v2 (invalidacija starog cachea na mobilnim uređajima)
