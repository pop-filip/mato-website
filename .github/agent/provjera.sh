#!/usr/bin/env bash
# Objektivna provjera za Agent Pipeline (matografie.at).
# Diže sajt lokalno iz repoa i provjerava invarijante koje moraju važiti posle
# SVAKE izmjene: config je validan, ulazne stranice vraćaju 200 i šalju svih šest
# security headera, a tačka-fajlovi su blokirani. Pokreću je agent.yml (prije PR-a)
# i provjera.yml (na svaki PR).
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

# --- podešavanja sajta ---
CONF=nginx/nginx.conf
WEBROOT=.
WEBROOT_KONT=/usr/share/nginx/html
ULAZ=("/" "/index.html")
UPSTREAM=()   # hostovi iz proxy_pass/fastcgi_pass, da nginx -t može da ih razriješi
# -------------------------

IME=agent-provjera
PORT=8080
PAD=0
greska() { echo "✗ $*"; PAD=1; }
HOSTOVI=()
for h in "${UPSTREAM[@]}"; do HOSTOVI+=(--add-host "$h:127.0.0.1"); done
MOUNT=(-v "$PWD/$CONF:/etc/nginx/conf.d/default.conf:ro" -v "$PWD/$WEBROOT:$WEBROOT_KONT:ro")

docker run --rm "${HOSTOVI[@]}" "${MOUNT[@]}" nginx:alpine nginx -t || exit 1
docker rm -f "$IME" >/dev/null 2>&1
docker run -d --name "$IME" -p "$PORT:80" "${HOSTOVI[@]}" "${MOUNT[@]}" nginx:alpine >/dev/null
trap 'docker rm -f "$IME" >/dev/null 2>&1' EXIT
for _ in $(seq 30); do curl -s -o /dev/null "localhost:$PORT/" && break; sleep 0.5; done

for p in "${ULAZ[@]}"; do
  kod=$(curl -s -o /dev/null -w '%{http_code}' "localhost:$PORT$p")
  [ "$kod" = 200 ] || greska "$p vraća $kod"
  h=$(curl -sI "localhost:$PORT$p" | tr -d '\r' | tr '[:upper:]' '[:lower:]')
  for x in strict-transport-security x-frame-options x-content-type-options referrer-policy permissions-policy content-security-policy; do
    grep -q "^$x:" <<<"$h" || greska "$p nema $x"
  done
done

for p in /.git/HEAD /.env /.gitignore; do
  kod=$(curl -s -o /dev/null -w '%{http_code}' "localhost:$PORT$p")
  case "$kod" in 403|404) ;; *) greska "$p vraća $kod (treba 403 ili 404)" ;; esac
done

[ "$PAD" = 0 ] && echo "✓ provjera prošla" || echo "provjera NIJE prošla"
exit "$PAD"
