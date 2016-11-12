#!/bin/sh

docker run -it --rm -v /home/travis/build/tslodki/getssl:/getssl $1 \
  -e CF_DOMAIN -e CF_EMAIL -e CF_KEY \
  bash -c "cd /getssl/dns_scripts; ../test/cf_tests.bash"
