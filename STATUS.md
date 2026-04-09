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
