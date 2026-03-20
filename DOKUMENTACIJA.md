# matografie.at — Tehnička Dokumentacija

## Tehnologije

| Tehnologija | Verzija | Uloga |
|---|---|---|
| HTML5 | — | Jednostranična aplikacija (SPA) |
| CSS3 | — | Inline critical CSS, animacije, responsivni dizajn |
| JavaScript | ES2020+ | Navigacija, animacije, forma, canvas, video lightbox |
| Font Awesome | 6.5.0 | Ikonice (WhatsApp, Viber, Signal, socijalne mreže) |
| nginx | alpine | Web server (Docker kontejner) |
| Docker | — | Lokalni development i deployment |
| Cloudflare Tunnel | — | HTTPS pristup bez portforwardinga |
| ffmpeg | — | Video kompresija |
| Web3Forms | — | Kontakt forma (serverless email) |
| GitHub Actions | — | CI/CD auto-deploy na Hetzner VPS |

---

## Domena

**Live domena:** `matografie.at`
**Canonical URL:** `https://matografie.at/`
**Email:** `info@mato-production.com`
**Telefon:** `+43 660 3780309`
**Lokacija:** Linz, Oberösterreich, Austria

---

## Fontovi

| Font | Težine | Upotreba |
|---|---|---|
| Playfair Display | 400, 700, 400i | Naslovi, hero tekst |
| Cormorant Garamond | 300, 400, 300i | Body tekst, opisi |

---

## Struktura fajlova

```
mato-website/
├── .github/
│   └── workflows/
│       └── deploy.yml              ← GitHub Actions CI/CD
├── index.html                      ← Produkcijski fajl
├── 404.html                        ← Custom 404 stranica
├── robots.txt                      ← SEO crawler instrukcije
├── sitemap.xml                     ← XML sitemap (hreflang en/de)
├── index.v.1.html                  ← Originalna v1 kopija
├── mato-portfolio-ORIGINAL-backup.html ← Backup originala
├── mato-portfolio-REDESIGN-test.html   ← Radna kopija redesigna
├── mato-portfolio-v4_43.html       ← Prethodna verzija
├── mato-portfolio-v4_43.BACKUP.html    ← Backup prethodne verzije
├── checklist.html                  ← Pregled optimizacija
├── compress-videos.sh              ← ffmpeg skripta za kompresiju videa
├── DOKUMENTACIJA.md                ← Ovaj fajl
├── videos/                         ← Originalni video fajlovi
│   ├── voda.mp4
│   ├── delta.mp4
│   ├── delta-team.mp4
│   └── skok.mp4
├── voda_compressed.mp4             ← Kompresovani videi (web ready)
├── delta_compressed.mp4
├── delta-team_compressed.mp4
└── skok_compressed.mp4
```

---

## Optimizacije — Checklist

### ⚡ Performance (5)
- ✅ `preconnect` za Google Fonts + cdnjs.cloudflare.com (DNS lookup speedup)
- ✅ Logo inline (WebP base64) — nema vanjskog HTTP zahtjeva, pojavljuje se odmah
- ✅ Favicon inline SVG — nema vanjskog zahtjeva, radi bez servera
- ✅ `will-change: transform` na animiranim elementima (GPU layer)
- ✅ Video kompresija — 4 videa kompresovana za web via ffmpeg

### 🔍 SEO (24)
- ✅ `<html lang="de-AT">` — primarni jezik austrijsko tržište
- ✅ Title tag — sa ključnim riječima: Videograf, Fotograf, Österreich, Hochzeit, Imagefilm, Portrait
- ✅ Meta description — na njemačkom kao primarni jezik (AT tržište)
- ✅ Meta robots — `max-snippet:-1, max-image-preview:large, max-video-preview:-1`
- ✅ Canonical URL → `https://matografie.at/`
- ✅ hreflang alternates (en, de, x-default) — dvojezično austrijsko tržište
- ✅ GEO meta — Linz koordinate (48.3069, 14.2858), regija AT-4
- ✅ Open Graph — type, url, title, description, image, locale (de_AT), locale:alternate (en_US), site_name
- ✅ Twitter Card (summary_large_image)
- ✅ `sitemap.xml` — XML sitemap sa hreflang alternates
- ✅ `robots.txt` — sa Sitemap referencom
- ✅ **Person** JSON-LD — ime, zanimanje, telefon, email, adresa, sameAs, contactPoint (DE/EN/HR)
- ✅ **LocalBusiness + ProfessionalService** JSON-LD — Google Maps, priceRange €€, openingHours, sameAs
- ✅ **5x Service** JSON-LD — sa opisima i cijenama (od €350 do €1200)
- ✅ **WebSite** JSON-LD — sa SearchAction
- ✅ **WebPage + BreadcrumbList** JSON-LD
- ✅ **ContactPage** JSON-LD — za #contact sekciju
- ✅ **4x VideoObject** JSON-LD — Voda, Skok, Delta, Delta Team sa contentUrl
- ✅ `sameAs` — Instagram, YouTube, Vimeo, TikTok (placeholder, čeka issue #10)
- ✅ `og-image.jpg` — placeholder 1200×630px dark/gold (čeka issue #9)
- ✅ `rel="noopener noreferrer"` na svim vanjskim linkovima
- ✅ `preconnect` + `dns-prefetch` za Web3Forms API
- ✅ **manifest.json** — PWA, short_name matografie, dark theme
- ✅ Apple Touch Icon + apple-mobile-web-app meta tagovi

### ♿ Pristupačnost — a11y (8)
- ✅ `lang="en"` atribut na `<html>`
- ✅ `prefers-reduced-motion` (animacije se gase za osjetljive korisnike)
- ✅ Skip-to-content link (keyboard navigacija)
- ✅ `role="main"` landmark
- ✅ `aria-label` + `aria-expanded` na hamburger meniju
- ✅ Form labels + `autocomplete` + `type="email"`
- ✅ `focus-visible` outline na form poljima (keyboard UX)
- ✅ Alt tekst na logo slici

### 🎨 UX & Design (7)
- ✅ WhatsApp / Viber / Signal dugmad u kontaktu
- ✅ DE / EN jezik switcher (austrijsko tržište)
- ✅ `scroll-behavior: smooth`
- ✅ Hamburger meni — samo mobile (≤700px)
- ✅ Video lightbox (fullscreen prikaz portfolio videa)
- ✅ Film grain canvas overlay (cinematski look)
- ✅ GDPR Cookie consent banner (localStorage, OK/Decline, animated dismiss)

### 📱 Mobile Fixes (4)
- ✅ Contact sekcija — `Let's shoot` centriran, `flex-start` za scroll, padding-bottom 320px
- ✅ Services sekcija — `padding-bottom:200px` za Portrait card vidljivost
- ✅ `-webkit-overflow-scrolling:touch` — iOS scroll fix
- ✅ Contact button `Senden` — vidljiv i klikabilni na svim uređajima

### 🐳 Infrastruktura (5)
- ✅ compress-videos.sh — ffmpeg batch skripta za kompresiju videa
- ✅ 4 kompresirana video fajla na disku (web ready)
- ✅ Cloudflare Quick Tunnel (HTTPS za demo/testiranje)
- ✅ GitHub Actions CI/CD — `workflow_dispatch` (ručno, aktivan kad VPS bude spreman)
- ✅ Custom 404.html — dark/gold dizajn koji prati estetiku sajta

### 📬 Forme & Komunikacija (1)
- ✅ Kontakt forma — Web3Forms integracija (`access_key` konfiguriran), async submit, success/error feedback

### 🔒 Sigurnost & GDPR (3)
- ✅ Cookie consent banner — GDPR compliant, opt-in/opt-out, localStorage persistencija
- ✅ Favicon PNG fallback — validan base64 PNG za starije browsere
- ✅ `rel="noopener noreferrer"` — svi vanjski linkovi zaštićeni

---

## SEO — Kako funkcionišu Keywords

**`<meta name="keywords">`** — Google ga ignoriše od 2009. Bing ga djelimično koristi. Ostavljamo ga ali nije prioritet.

**Što Google stvarno gleda (po važnosti):**
1. **Title tag** — najvažniji signal, max 60 znakova
2. **Meta description** — utječe na CTR (click-through rate), max 160 znakova
3. **H1/H2 naslovi** — ključne riječi u naslovima sekcija
4. **Tekst na stranici** — prirodno korištenje ključnih riječi
5. **Schema.org markup** — strukturirani podaci za rich results
6. **Backlinks** — vanjski linkovi koji pokazuju na sajt
7. **Core Web Vitals** — brzina, stabilnost, interaktivnost

**Trenutni title:** `Mato Davidovic — Videograf & Fotograf Österreich | Hochzeit · Imagefilm · Portrait`

**Ciljane ključne riječi:**
- Primarne: `Videograf Österreich`, `Fotograf Österreich`, `Hochzeitsvideograf`
- Sekundarne: `Imagefilm Wien/Linz`, `Kameramann Linz`, `Drohnenaufnahmen Österreich`
- Brand: `matografie`, `matografie.at`

---

## Schema.org — Struktura

```
@graph
├── Person (Mato Davidovic — kontakt, lokacija, vještine)
├── LocalBusiness + ProfessionalService (Google Maps, priceRange €€)
│   └── hasOfferCatalog
│       ├── Service: Hochzeitsvideografie (od €1200)
│       ├── Service: Imagefilm & Brand Commercial (od €800)
│       ├── Service: Drohnenaufnahmen (od €400)
│       ├── Service: Portrait & Lifestyle (od €350)
│       └── Service: Travel & Dokumentarfilm
├── WebSite (sa SearchAction)
└── WebPage + BreadcrumbList
```

---

## GitHub Actions — CI/CD Setup

Fajl: `.github/workflows/deploy.yml`
**Status: `workflow_dispatch`** — ručno pokretanje, automatski deploy deaktiviran dok VPS nije spreman.

### Aktivacija auto-deploya
Kad VPS bude spreman, u `deploy.yml` promijeni:
```yaml
on:
  workflow_dispatch:
```
u:
```yaml
on:
  push:
    branches:
      - main
```

### Potrebni GitHub Secrets
Dodati u: **GitHub repo → Settings → Secrets and variables → Actions**

| Secret | Vrijednost |
|---|---|
| `VPS_HOST` | IP adresa Hetzner VPS-a |
| `VPS_USER` | SSH korisnik (npr. `root`) |
| `VPS_SSH_KEY` | Privatni SSH ključ (sadržaj `~/.ssh/id_rsa`) |

---

## Web3Forms — Kontakt Forma

- API endpoint: `https://api.web3forms.com/submit`
- `access_key` konfiguriran direktno u `index.html` (JS sekcija ~linija 2650)
- Bot protection: honeypot polje `botcheck` (hidden checkbox)
- Feedback: inline success (zeleno) / error (crveno) poruke
- Button tekst: `Senden`
- Za promjenu email primaoca: [web3forms.com](https://web3forms.com) → promijeni `access_key`
- **Napomena:** Web3Forms ne radi lokalno (`file://`, `localhost`) — testirati samo sa live domenom ili Cloudflare tunelom

---

## Cookie Consent — GDPR

- Banner se pojavljuje **samo pri prvoj posjeti**
- Korisnik bira: **OK** ili **Decline**
- Izbor se čuva u `localStorage` (`cookie-consent: accepted/declined`)
- Pri svakom sljedećem učitavanju banner se **ne prikazuje ponovo** — ovo je ispravno GDPR ponašanje
- Privacy Policy link otvara Imprint/Privacy sekciju unutar sajta
- **Reset za testiranje:** DevTools → Application → Local Storage → obriši `cookie-consent`

---

## GA4 — Google Analytics Setup

- Kod je **komentarisan** u `index.html` (iza DNS prefetch sekcije, ~linija 52)
- Poštuje cookie consent — aktivira se samo ako korisnik klikne **OK**
- `anonymize_ip: true` — GDPR compliant
- **Aktivacija:** See issue [#15](https://github.com/pop-filip/mato-website/issues/15)

### Kako aktivirati (nakon go-live)
1. analytics.google.com → Admin → Create Property → Web
2. Kopiraj Measurement ID: `G-XXXXXXXXXX`
3. U `index.html` pronađi blok s komentarom `GA4 — Google Analytics`
4. Uncommentati `<script>` blok i zamijeniti `GA_MEASUREMENT_ID`
5. Testirati u GA4 → DebugView

---

## Heading Audit (2026-03-20)

| Heading | Tekst | Status |
|---|---|---|
| H1 (visually-hidden) | `Mato Davidovic — Videograf & Fotograf Österreich \| Hochzeitsfilm · Imagefilm · Portrait` | ✅ Optimizirano |
| H2 Services | `My Services` + hidden: `Videografie & Fotografie Österreich: Hochzeitsfilm, Imagefilm, Drohnen, Portrait` | ✅ Optimizirano |
| H3 Service items | Cinematic, Wedding, Travel, Brand, Portrait | ✅ Opisni |
| H2 Work | `The Reel / Das Portfolio` | ✅ Dvojezično |
| H2 Contact | `Let's shoot` + hidden: `Videograf & Fotograf anfragen \| Linz, Österreich` | ✅ Optimizirano |

**Tehnika:** `<span class="visually-hidden">` — vidljiv search engineu i screen readerima, nevidljiv korisnicima. Dizajn ostaje netaknut.

---

## Nginx Security Headers — TODO (nakon VPS setup-a)

Dodati u nginx config kad server bude live:

```nginx
add_header X-Frame-Options "DENY";
add_header X-Content-Type-Options "nosniff";
add_header Referrer-Policy "strict-origin-when-cross-origin";
add_header Permissions-Policy "camera=(), microphone=(), geolocation=()";
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' https://api.web3forms.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com; font-src https://fonts.gstatic.com https://cdnjs.cloudflare.com; img-src 'self' data:; connect-src https://api.web3forms.com;";
```

---

## GitHub Issues — Tracker

Sve otvorene zadatke pratimo na: **https://github.com/pop-filip/mato-website/issues**

| Issue | Naslov | Prioritet | Ovisi o |
|---|---|---|---|
| [#6](https://github.com/pop-filip/mato-website/issues/6) | Go Live — Hetzner VPS + domena `matografie.at` | 🔴 Visok | — |
| [#9](https://github.com/pop-filip/mato-website/issues/9) | `og-image.jpg` — prava fotografija (1200×630) | 🔴 Visok | — |
| [#10](https://github.com/pop-filip/mato-website/issues/10) | Social media linkovi — footer + schema sameAs | 🟡 Srednji | — |
| [#11](https://github.com/pop-filip/mato-website/issues/11) | Google Search Console — verifikacija + sitemap | 🔴 Visok | #6 |
| [#12](https://github.com/pop-filip/mato-website/issues/12) | Nginx security headers (CSP, HSTS, X-Frame-Options) | 🟡 Srednji | #6 |
| [#13](https://github.com/pop-filip/mato-website/issues/13) | GitHub Actions — Secrets + aktivacija auto-deploya | 🔴 Visok | #6 |
| [#14](https://github.com/pop-filip/mato-website/issues/14) | VideoObject schema — pravi datumi i opisi videa | 🟢 Nizak | — |
| [#15](https://github.com/pop-filip/mato-website/issues/15) | GA4 — Google Analytics aktivacija | 🟡 Srednji | #6 |
| [#16](https://github.com/pop-filip/mato-website/issues/16) | Heading audit — H2/H3 keyword optimizacija | 🟢 Nizak | — |

### Redoslijed rada

```
Sada (lokalno):
  #9  → og-image.jpg prava fotografija
  #10 → social media linkovi
  #16 → heading audit (H2/H3 keyword optimizacija)

Nakon go-live (#6):
  #13 → GitHub Secrets + auto-deploy
  #11 → Google Search Console
  #12 → Nginx security headers
  #15 → GA4 aktivacija (kod već u index.html, samo uncommentati)
  #14 → VideoObject finalizacija
```
