#! /usr/bin/env bash
echo "Checking if $CF_DOMAIN exists at Cloudflare"
CURLP=(
  --silent
  -H "X-Auth-Email: $CF_EMAIL"
  -H "X-Auth-Key: $CF_KEY"
  -H 'Content-Type: application/json'
  'https://api.cloudflare.com/client/v4/zones'
)
if curl "${CURLP[@]}" | grep -Fwvq "$CF_DOMAIN"; then
  echo "Creating $CF_DOMAIN at Cloudflare..."
  curl -X POST "${CURLP[@]}" --data "{\"name\":\"$CF_DOMAIN\",\"jump_start\":false}"
  echo
fi
echo done.
