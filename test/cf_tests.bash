#! /usr/bin/env bash
$BVER -c "echo Testing with Bash version: \$BASH_VERSION"
# shellcheck source=/dev/null
. ../test/assert.sh

assert_raises "$BVER dns_add_cloudflare" 1
assert_raises "$BVER dns_add_cloudflare ''" 1
assert_raises "$BVER dns_add_cloudflare '' ''" 1
assert_raises "$BVER dns_add_cloudflare domain.us" 1
assert_raises "$BVER dns_add_cloudflare domain.us ''" 1
assert_raises "$BVER dns_add_cloudflare domain.x a" 1
assert_raises "$BVER dns_add_cloudflare domain a" 1
assert_raises "$BVER dns_add_cloudflare domain_.us a" 1
assert_raises "$BVER dns_add_cloudflare -domain.us a" 1
assert_raises "$BVER dns_add_cloudflare sub.-domain.us a" 1
assert_raises "CF_EMAIL=we.org $BVER dns_add_cloudflare a.$CF_DOMAIN a" 1
assert_raises "CF_KEY=123 $BVER dns_add_cloudflare a.$CF_DOMAIN a" 1
assert_raises "CF_KEY=12345678901234567890123456789012456w $BVER dns_add_cloudflare a.$CF_DOMAIN a" 1

assert "CF_EMAIL=w@e.org $BVER dns_add_cloudflare a.$CF_DOMAIN a" \
  'Error reading domains from Cloudflare: Unknown X-Auth-Key or X-Auth-Email'
assert_raises "CF_EMAIL=w@e.org $BVER dns_add_cloudflare a.$CF_DOMAIN a" 3

assert "CF_KEY=${CF_KEY%???}000 $BVER dns_add_cloudflare a.$CF_DOMAIN a" \
  'Error reading domains from Cloudflare: Unknown X-Auth-Key or X-Auth-Email'
assert_raises "CF_KEY=${CF_KEY%???}000 $BVER dns_add_cloudflare a.$CF_DOMAIN a" 3

assert_end dns_add_cloudflare params

assert "$BVER dns_add_cloudflare missing.us a" \
  'Domain for missing.us not found on Cloudflare account'
assert_raises "$BVER dns_add_cloudflare missing.us a" 3

assert "$BVER dns_add_cloudflare t1.$CF_DOMAIN t1" ''
assert "$BVER dns_add_cloudflare t1.$CF_DOMAIN t1" \
  'DNS challenge token already exists'
assert_raises "$BVER dns_add_cloudflare t1.$CF_DOMAIN t1" 0
assert "$BVER dns_add_cloudflare t1.$CF_DOMAIN t2" ''
assert_raises "$BVER dns_add_cloudflare t1.$CF_DOMAIN t3" 0

assert "$BVER dns_add_cloudflare t-4.subdomain.$CF_DOMAIN t4" ''
assert_raises "$BVER dns_add_cloudflare t-4.subdomain.$CF_DOMAIN t4" 0

assert "$BVER dns_add_cloudflare $CF_DOMAIN t5" ''
assert_raises "$BVER dns_add_cloudflare $CF_DOMAIN t5" 0

assert_end dns_add_cloudflare API

assert_end dns_del_cloudflare params

assert_raises "$BVER dns_del_cloudflare t1.$CF_DOMAIN" 0
assert_raises "$BVER dns_del_cloudflare t-4.subdomain.$CF_DOMAIN" 0
assert_raises "$BVER dns_del_cloudflare $CF_DOMAIN" 0

assert_end dns_del_cloudflare API
