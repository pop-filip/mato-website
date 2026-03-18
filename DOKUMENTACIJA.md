# Mato Davidovic — Tehnička Dokumentacija

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
├── index.html                          ← Produkcijski fajl
├── index.v.1.html                      ← Originalna v1 kopija
├── mato-portfolio-ORIGINAL-backup.html ← Backup originala
├── mato-portfolio-REDESIGN-test.html   ← Radna kopija redesigna
├── mato-portfolio-v4_43.html           ← Prethodna verzija
├── mato-portfolio-v4_43.BACKUP.html    ← Backup prethodne verzije
├── checklist.html                      ← Pregled optimizacija
├── compress-videos.sh                  ← ffmpeg skripta za kompresiju videa
├── videos/                             ← Originalni video fajlovi
│   ├── voda.mp4
│   ├── delta.mp4
│   ├── delta-team.mp4
│   └── skok.mp4
├── voda_compressed.mp4                 ← Kompresovani videi (web ready)
├── delta_compressed.mp4
├── delta-team_compressed.mp4
├── skok_compressed.mp4
└── DOKUMENTACIJA.md                    ← Ovaj fajl
```

---

## Optimizacije — Checklist

### ⚡ Performance (5)
- ✅ `preconnect` za Google Fonts + cdnjs.cloudflare.com (DNS lookup speedup)
- ✅ Logo inline (WebP base64) — nema vanjskog HTTP zahtjeva, pojavljuje se odmah
- ✅ Favicon inline SVG — nema vanjskog zahtjeva, radi bez servera
- ✅ `will-change: transform` na animiranim elementima (GPU layer)
- ✅ Video kompresija — 4 videa (voda, delta, delta-team, skok) kompresovana za web via ffmpeg

### 🔍 SEO (8)
- ✅ Title tag (sa ključnom riječju "Austria" i zanimanjem)
- ✅ Meta description + robots: index, follow
- ✅ Canonical URL
- ✅ hreflang alternates (en, de, x-default) — kritično za austrijsko dvojezično tržište
- ✅ Open Graph prošireni (og:type, url, title, description, image, width, height, alt, locale, site_name)
- ✅ Twitter Card (summary_large_image)
- ✅ Person JSON-LD Schema (ime, zanimanje, lokacija, kontakt, sameAs)
- ✅ Organization JSON-LD Schema (vizuelna produkcija, usluge, kontakt)

### ♿ Pristupačnost — a11y (8)
- ✅ `lang="en"` atribut na `<html>`
- ✅ `prefers-reduced-motion` (animacije se gase za osjetljive korisnike)
- ✅ Skip-to-content link (keyboard navigacija)
- ✅ `role="main"` landmark
- ✅ `aria-label` + `aria-expanded` na hamburger meniju
- ✅ Form labels + `autocomplete` + `type="email"`
- ✅ `focus-visible` outline na form poljima (keyboard UX)
- ✅ Alt tekst na logo slici

### 🎨 UX & Design (6)
- ✅ WhatsApp / Viber / Signal dugmad u kontaktu
- ✅ DE / EN jezik switcher (austrijsko tržište)
- ✅ `scroll-behavior: smooth`
- ✅ Hamburger meni — samo mobile (≤700px)
- ✅ Video lightbox (fullscreen prikaz portfolio videa)
- ✅ Film grain canvas overlay (cinematski look)

### 🐳 Infrastruktura (3)
- ✅ compress-videos.sh — ffmpeg batch skripta za kompresiju videa
- ✅ 4 kompresirana video fajla na disku (web ready)
- ✅ Cloudflare Quick Tunnel (HTTPS za demo)

---

## Čekajući zadaci

| # | Zadatak | Prioritet |
|---|---|---|
| 1 | Kontakt forma (Web3Forms ili EmailJS) | Visok |
| 2 | `sitemap.xml` | Srednji |
| 3 | `robots.txt` | Srednji |
| 4 | `404.html` stranica | Srednji |
| 5 | Cookie consent (GDPR — Austria/EU) | Visok |
| 6 | Go Live — hosting i domena `mato-davidovic.at` | Visok |
| 7 | Favicon PNG fallback za starije browsere | Nizak |
