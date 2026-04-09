# matografie.at — Tehnička Dokumentacija

**Posljednji update:** 2026-04-09
**Status:** LIVE ✅

---

## Kompletan Tech Stack

### Frontend
| Tehnologija | Uloga |
|---|---|
| **HTML5** | Jednostranična aplikacija (SPA) — jedan `index.html` fajl |
| **CSS3** | Inline critical CSS direktno u `<head>` — nema vanjskih CSS fajlova, nulti HTTP request |
| **JavaScript (ES2020+)** | Navigacija, animacije, video player, forma, canvas grain, cookie consent, lang switcher |
| **Font Awesome 6.5.0** | Ikonice (WhatsApp, Viber, Signal) — async load, ne blokira render |
| **Google Fonts** | Playfair Display + Cormorant Garamond — preconnect optimizacija |
| **Canvas API** | Film grain overlay efekt za cinematski izgled |

### Backend / Infrastruktura
| Tehnologija | Uloga |
|---|---|
| **Hetzner VPS** | Produkcijski server — Ubuntu, IP: `157.180.67.68` |
| **Docker** | Kontejnerizacija — svaki sajt u svom nginx:alpine containeru |
| **nginx (alpine)** | Web server unutar Docker containera — servira statičke fajlove |
| **Traefik v2** | Reverse proxy — routing po domeni, automatski Let's Encrypt SSL, HTTPS redirect |
| **Let's Encrypt** | Besplatni SSL certifikat — automatska obnova kroz Traefik |
| **GitHub Actions** | CI/CD — svaki `git push → main` automatski deploya na VPS via rsync |
| **rsync** | Deploy mehanizam — prenosi samo promijenjene fajlove, brzo |
| **Web3Forms** | Serverless kontakt forma — prima poruke, šalje email, nema backend-a |

### Analytics & Monitoring
| Tehnologija | Uloga |
|---|---|
| **Google Analytics 4** | Praćenje posjeta — Measurement ID: `G-7GR6CR1J9G` |
| **Google Search Console** | SEO monitoring — verifikovan, sitemap submitovan |
| **Cookie Consent** | GDPR — GA4 se aktivira samo ako korisnik klikne OK |

### Alati (development)
| Alat | Uloga |
|---|---|
| **ffmpeg** | Video kompresija — batch skripta `compress-videos.sh` |
| **Git + GitHub** | Verzioniranje koda — repo: `pop-filip/mato-website` |

---

## Infrastruktura — Kako funkcioniše

```
Korisnik (browser)
      │
      ▼
Traefik (157.180.67.68:443)
  - Prima HTTPS zahtjev za matografie.at
  - Let's Encrypt SSL certifikat
  - Prosljeđuje na Docker container
      │
      ▼
Docker container: mato-website (nginx:alpine)
  - Web root: /var/www/mato-website/html/
  - Config: /var/www/mato-website/nginx.conf
  - Servira statičke fajlove
      │
      ▼
index.html + videi + logo + sw.js
```

**Deploy flow:**
```
git push → main
      │
      ▼
GitHub Actions (deploy.yml)
  - rsync fajlova → /var/www/mato-website/html/
  - nginx reload u containeru
  - ✅ Live za ~30 sekundi
```

---

## Domena & Kontakt

| Stavka | Vrijednost |
|---|---|
| **Domena** | `matografie.at` |
| **Canonical URL** | `https://matografie.at/` |
| **Server IP** | `157.180.67.68` |
| **Email** | `info@mato-production.com` |
| **Telefon** | `+43 660 3780309` |
| **Lokacija** | Linz, Oberösterreich, Austria |

---

## Struktura fajlova

```
mato-website/
├── .github/
│   └── workflows/
│       └── deploy.yml              ← GitHub Actions CI/CD (push → main = auto deploy)
├── index.html                      ← Jedini produkcijski fajl (SPA)
├── 404.html                        ← Custom 404 stranica (dark/gold dizajn)
├── og-image.jpg                    ← Social share slika 1200×630px (B&W portrait iz voda videa)
├── logo.webp                       ← Logo (vanjski fajl, browser kešira)
├── robots.txt                      ← Crawler instrukcije — blokira test/backup fajlove
├── sitemap.xml                     ← XML sitemap sa hreflang (en/de)
├── manifest.json                   ← PWA manifest (dark theme, standalone)
├── sw.js                           ← Service Worker (offline cache-first)
├── compress-videos.sh              ← ffmpeg skripta za kompresiju videa
├── DOKUMENTACIJA.md                ← Ovaj fajl
├── STATUS.md                       ← Trenutni status projekta
├── videos/                         ← Kompresovani web videi
│   ├── voda_compressed.mp4         ← Portrait u vodi (1.3MB)
│   ├── voda_compressed.webm        ← WebM verzija (1.5MB)
│   ├── skok_compressed.mp4         ← Skydiving (12MB)
│   ├── skok_compressed.webm        ← WebM verzija (36MB — mp4 bolji ovdje)
│   ├── delta_compressed.mp4        ← Delta projekat (9.2MB)
│   ├── delta-team_compressed.mp4   ← Delta Team projekat (8.2MB)
│   └── matografie_compressed.webm  ← Hero video (14MB)
├── contact_compressed.mp4          ← Hamburger meni background video (981KB)
│
├── index.v.1.html                  ← Originalna v1 (referenca) [robots: Disallow]
├── mato-portfolio-v4_43.html       ← Prethodna verzija [robots: Disallow]
├── mato-portfolio-v4_43.BACKUP.html [robots: Disallow]
├── mato-portfolio-ORIGINAL-backup-20260316.html [robots: Disallow]
├── mato-portfolio-REDESIGN-test.html [robots: Disallow]
├── hamburger-test.html             ← Standalone test [robots: Disallow]
└── checklist.html                  ← Pregled optimizacija [robots: Disallow]
```

---

## Security Headers (nginx)

Konfigurirani u `/var/www/mato-website/nginx.conf` na serveru:

| Header | Vrijednost | Za što je |
|---|---|---|
| `X-Frame-Options` | SAMEORIGIN | Sprječava clickjacking — sajt se ne može embedati u iframe |
| `X-Content-Type-Options` | nosniff | Browser ne smije "pogađati" tip fajla — sprječava MIME sniffing napade |
| `Referrer-Policy` | strict-origin-when-cross-origin | Kontroliše koji URL se šalje kao referrer vanjskim sajtovima |
| `Permissions-Policy` | camera/mic/geoloc blocked | Blokira pristup kameri, mikrofonu, lokaciji |
| `Strict-Transport-Security` | max-age=31536000; includeSubDomains | Forsira HTTPS na 1 godinu — HSTS |
| `Content-Security-Policy` | (detaljna, vidi ispod) | Whitelist za sve resurse — blokira XSS napade |

**CSP whitelist:**
- Scripts: `self`, inline, googletagmanager.com, google-analytics.com
- Styles: `self`, inline, fonts.googleapis.com, cdnjs.cloudflare.com
- Fonts: fonts.gstatic.com, cdnjs.cloudflare.com
- Images: `self`, data URIs, https (sve)
- Media: `self` (videi)
- Connect: `self`, web3forms.com, google-analytics.com
- Frames: youtube.com (za hero video embed)
- Workers: `self` (Service Worker)

---

## SEO Stack

### Meta tagovi
- Title, description, robots, author, canonical
- `lang="de-AT"` — austrijsko tržište primarno
- hreflang: `en`, `de`, `x-default`
- Geo meta: Linz koordinate (48.3069, 14.2858), regija AT-4
- `color-scheme: dark` — browser ne bljesne bijelom

### Open Graph (dijeljenje na mrežama)
- og:title, description, url, image, video, locale (de_AT + en_US)
- `og-image.jpg` — 1200×630px B&W cinematic portrait (kadar iz voda videa, 2s)
- og:video — matografie_compressed.mp4 (video preview na Facebook/LinkedIn)

### Twitter Card
- summary_large_image, title, description, image, image:alt

### Schema.org (JSON-LD)
| Tip | Za što je |
|---|---|
| `Person` | Mato kao osoba — ime, kontakt, lokacija, sameAs linkovi |
| `LocalBusiness + ProfessionalService` | Google Maps integracija, openingHours, priceRange €€ |
| `5x Service` | Hochzeitsvideo, Imagefilm, Drohnen, Portrait, Travel — sa cijenama |
| `WebSite` | SearchAction (Google Sitelinks Search Box) |
| `WebPage + BreadcrumbList` | Navigacijska struktura za Google |
| `ContactPage` | Kontakt sekcija |
| `4x VideoObject` | Voda, Skok, Delta, Delta Team — za Google Video rich results |
| `FAQPage` | 6 Q&A na njemačkom — FAQ rich results u Google |
| `SpeakableSpecification` | Označava sekcije za Google Assistant voice search |

### Ostalo
- `sitemap.xml` — sa hreflang alternates, submitovan u Search Console
- `robots.txt` — Allow: /, Disallow: svi test/backup fajlovi

---

## Performance Optimizacije

### Učitavanje resursa
- `<link rel="preload">` za `logo.webp`, hero video, contact video
- `<link rel="preconnect">` za Google Fonts, Cloudflare, Web3Forms
- `<link rel="dns-prefetch">` za GA4, GTM, Web3Forms
- Font Awesome async load — `onload="this.onload=null;this.rel='stylesheet'"` (ne blokira render)
- `fetchpriority="high"` na hero video elementu

### Caching (nginx)
- HTML fajlovi: `no-cache, no-store` — uvijek svježe
- Assets (jpg, webp, mp4, woff2...): `30 dana, immutable`

### Kompresija
- nginx gzip — sve tekstualne datoteke
- Videi: ffmpeg kompresija — skok 4x manji od originala, kontakt video 10x manji
- WebM format za neke videe (VP9 codec)

### PWA
- `manifest.json` — installable, standalone display, dark theme
- `sw.js` — cache-first za statiku, network-first za navigaciju
- Radi offline (keširani resursi)

---

## Fontovi

| Font | Težine | Upotreba |
|---|---|---|
| Playfair Display | 400, 700, 400i | Naslovi, hero tekst |
| Cormorant Garamond | 300, 400, 300i | Body tekst, opisi |

Učitavaju se sa Google Fonts sa `&subset=latin` (samo latinična slova) i `display=swap`.

---

## Videi — Kompresija

Batch skripta: `compress-videos.sh`

```bash
# Primjer kompresije:
ffmpeg -i input.mp4 -vf "scale=1920:-2" -c:v libx264 -crf 23 -preset slow -an -movflags +faststart output_compressed.mp4
```

| Video | Original | Kompresovan | Smanjenje |
|---|---|---|---|
| contact.mp4 | 9.7MB | 981KB | 90% |
| skok.mp4 | ~50MB | 12MB | 76% |
| delta.mp4 | ~40MB | 9.2MB | 77% |
| delta-team.mp4 | ~35MB | 8.2MB | 77% |
| voda.mp4 | 12MB | 1.3MB | 89% |

**og-image.jpg:** Kadar iz `voda_compressed.mp4` na 2s timestampu, 1200×630px, 97KB.
```bash
ffmpeg -i videos/voda_compressed.mp4 -ss 00:00:02 -vframes 1 -vf "scale=1200:630:force_original_aspect_ratio=increase,crop=1200:630" -update 1 -q:v 1 og-image.jpg
```

---

## Hamburger Meni

**Stil:** Aperture/Lens kružno dugme (CSS `::before`/`::after` lens ring), rotira 90° kad je otvoren.

**Video pozadina (mobile ≤700px):**
- Fajl: `contact_compressed.mp4` (981KB, 720×1280, 30fps, bez audia)
- Fiksiran iza menija (z-index:98), meni je polu-transparentan
- Fade in/out via `.menu-video.visible { opacity:0.45 }`
- JS: hamburger click → `play()` + `.visible`; zatvaranje → ukloni klasu, `pause()` nakon 600ms

---

## Kontakt Forma (Web3Forms)

- API: `https://api.web3forms.com/submit`
- `access_key` u `index.html` (JS sekcija)
- Honeypot: skriveni `botcheck` checkbox (bot zaštita)
- Feedback: inline zeleno/crveno
- **Napomena:** Ne radi lokalno (`file://`) — samo sa live domenom

Za promjenu email primaoca: **web3forms.com** → novi `access_key`.

---

## Cookie Consent & GDPR

- Banner pri prvoj posjeti — **OK** ili **Decline**
- Izbor se pamti u `localStorage` (`cookie-consent: accepted/declined`)
- GA4 se aktivira **samo ako korisnik klikne OK**
- `anonymize_ip: true` — GDPR compliant
- Privacy Policy link → modal sa pravima korisnika (GDPR Art. 6)
- **Reset za testiranje:** DevTools → Application → Local Storage → obriši `cookie-consent`

---

## Google Analytics 4

- **Measurement ID:** `G-7GR6CR1J9G`
- Aktivan na: `https://matografie.at`
- Cookie-consent aware — pali se samo uz pristanak
- **Search Console:** verifikovan, sitemap submitovan 2026-04-09

---

## GitHub Actions — CI/CD

Fajl: `.github/workflows/deploy.yml`

**Trigger:** `push → main`

**Koraci:**
1. Checkout koda
2. rsync fajlova na `/var/www/mato-website/html/` (preskače `.git`, `*.mp4`, `node_modules`)
3. `docker exec mato-website nginx -s reload`

**Secrets (postavljeni):**

| Secret | Vrijednost |
|---|---|
| `VPS_HOST` | 157.180.67.68 |
| `VPS_USER` | root |
| `VPS_SSH_KEY` | SSH privatni ključ |

**Napomena:** MP4 videi se ne deployaju automatski (preveliki za rsync pri svakom pushu). Videi se deployaju ručno jednom: `rsync -avz videos/ root@157.180.67.68:/var/www/mato-website/html/videos/`

---

## Nginx Config (Server)

Lokacija: `/var/www/mato-website/nginx.conf`

- gzip kompresija (html, css, js, json, svg)
- Security headeri u svakom location bloku (nginx inheritance bug fix)
- HTML: `no-cache` — uvijek svježe
- Assets: `30d immutable` — agresivni caching
- SPA fallback: `try_files $uri $uri/ /index.html`
- Error: `error_page 404 /404.html`

---

## Accessibility (a11y)

- `lang="de-AT"` na `<html>` elementu
- Skip-to-content link (keyboard navigacija)
- `role="main"`, `role="dialog"` landmarks
- `aria-label`, `aria-expanded`, `aria-hidden` na interaktivnim elementima
- `sr-only` klasa na form labelama (vidljivo screen readerima)
- `@media prefers-reduced-motion` — sve animacije se gase
- Form `autocomplete` atributi, `type="email"` validacija

---

## Heading Struktura (SEO)

| Heading | Tekst | Napomena |
|---|---|---|
| H1 (visually-hidden) | `Mato Davidovic — Videograf & Fotograf Österreich` | SEO, nevidljiv korisnicima |
| H2 Services | `My Services` + hidden keyword tekst | Dvojezično |
| H3 Services | Cinematic, Wedding, Travel, Brand, Portrait | Opisni |
| H2 Work | `The Reel / Das Portfolio` | Dvojezično |
| H2 Contact | `Let's shoot` + hidden keyword tekst | Optimizirano |

**Tehnika:** `<span class="visually-hidden">` — vidljiv Googleu, nevidljiv korisnicima.

---

## GitHub Issues — Status

| Issue | Naslov | Status |
|---|---|---|
| ~~#6~~ | Go Live — Hetzner VPS + domena | ✅ Zatvoreno |
| ~~#9~~ | og-image.jpg — prava fotografija | ✅ Zatvoreno (B&W portrait, voda 2s) |
| ~~#11~~ | Google Search Console | ✅ Zatvoreno (verifikovan + sitemap) |
| ~~#12~~ | Nginx security headers (CSP, HSTS) | ✅ Zatvoreno (kompletan stack) |
| ~~#13~~ | GitHub Actions auto-deploy | ✅ Zatvoreno (aktivan, tesiran) |
| ~~#15~~ | GA4 Analytics | ✅ Zatvoreno (G-7GR6CR1J9G) |
| ~~#20~~ | Mobile: Work "The Reel" cut off | ✅ Zatvoreno (padding fix) |
| ~~#21~~ | Work: The Reel ispod nava | ✅ Zatvoreno |
| ~~#22~~ | Services mobile iOS scroll | ✅ Zatvoreno |
| ~~#23~~ | Mobile: About layout | ✅ Zatvoreno (konsolidovani CSS) |
| #10 | Social media linkovi | ⏳ Čeka Mato (SM profili) |
| #14 | VideoObject datumi/opisi | ⏳ Čeka Mato (datumi snimanja) |
| #17 | Blog / Case Studies | 🔮 Long-term |
| #18 | E2E testovi (Playwright) | 🔮 Long-term |
| #19 | Next.js migracija | 🔮 Long-term |
