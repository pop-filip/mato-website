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
| Web3Forms | — | Kontakt forma (serverless email) |
| GitHub Actions | — | CI/CD auto-deploy na Hetzner VPS |

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
- ✅ Video kompresija — 4 videa (voda, delta, delta-team, skok) kompresovana za web via ffmpeg

### 🔍 SEO (10)
- ✅ Title tag (sa ključnom riječju "Austria" i zanimanjem)
- ✅ Meta description + robots: index, follow
- ✅ Canonical URL
- ✅ hreflang alternates (en, de, x-default) — kritično za austrijsko dvojezično tržište
- ✅ Open Graph prošireni (og:type, url, title, description, image, width, height, alt, locale, site_name)
- ✅ Twitter Card (summary_large_image)
- ✅ Person JSON-LD Schema (ime, zanimanje, lokacija, kontakt, sameAs)
- ✅ Organization JSON-LD Schema (vizuelna produkcija, usluge, kontakt)
- ✅ `sitemap.xml` — XML sitemap sa hreflang alternates (en/de/x-default)
- ✅ `robots.txt` — crawler instrukcije sa Sitemap referencom

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
- ✅ GDPR Cookie consent banner (localStorage, accept/decline, animated dismiss)

### 🐳 Infrastruktura (5)
- ✅ compress-videos.sh — ffmpeg batch skripta za kompresiju videa
- ✅ 4 kompresirana video fajla na disku (web ready)
- ✅ Cloudflare Quick Tunnel (HTTPS za demo)
- ✅ GitHub Actions CI/CD — auto-deploy na Hetzner VPS pri push na `main`
- ✅ Custom 404.html — dark/gold design koji prati estetiku sajta

### 📬 Forme & Komunikacija (1)
- ✅ Kontakt forma — Web3Forms integracija (`access_key` konfiguriran), async submit, success/error feedback

### 🔒 Sigurnost & GDPR (2)
- ✅ Cookie consent banner — GDPR compliant, opt-in/opt-out, localStorage persistencija
- ✅ Favicon PNG fallback — validan base64 PNG za starije browsere (IE, legacy)

---

## GitHub Actions — CI/CD Setup

Fajl: `.github/workflows/deploy.yml`

Auto-deploy se pokreće na svaki `git push` na `main` branch.

### Potrebni GitHub Secrets

Dodati u: **GitHub repo → Settings → Secrets and variables → Actions**

| Secret | Vrijednost |
|---|---|
| `VPS_HOST` | IP adresa Hetzner VPS-a |
| `VPS_USER` | SSH korisnik (npr. `root`) |
| `VPS_SSH_KEY` | Privatni SSH ključ (sadržaj `~/.ssh/id_rsa`) |

### Workflow koraci
1. Checkout koda
2. SSH na VPS
3. `git pull origin main` na serveru
4. `docker compose up -d --build` — rebuild i restart kontejnera

---

## Web3Forms — Kontakt Forma

- API endpoint: `https://api.web3forms.com/submit`
- `access_key` je konfiguriran direktno u `index.html` (JS sekcija)
- Bot protection: honeypot polje `botcheck` (hidden checkbox)
- Feedback: inline success (zeleno) / error (crveno) poruke
- Za promjenu email primaoca: prijaviti se na [web3forms.com](https://web3forms.com) i izmjeniti ključ

---

## Cookie Consent — GDPR

- Banner se pojavljuje pri prvoj posjeti
- Korisnik bira: **Accept** ili **Decline**
- Izbor se čuva u `localStorage` (`cookie-consent: accepted/declined`)
- Pri svakom sljedećem učitavanju banner se ne prikazuje
- Privacy Policy link otvara Imprint/Privacy sekciju unutar sajta

---

## Čekajući zadaci

| # | Zadatak | Prioritet |
|---|---|---|
| 6 | Go Live — hosting i domena `mato-davidovic.at` | Visok |
| — | Dodati GitHub Secrets (VPS_HOST, VPS_USER, VPS_SSH_KEY) | Visok |
| — | Instagram / YouTube / Vimeo / TikTok linkovi u footeru | Srednji |
