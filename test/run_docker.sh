#!/bin/sh
# run test suite inside docker with selected bash version with curl added
docker run -it --rm -v /home/travis/build/tslodki/getssl:/getssl \
  -e CF_DOMAIN -e CF_EMAIL -e CF_KEY "$1" \
  bash -c "apk --no-cache --no-progress -q add curl; cd /getssl/dns_scripts; ../test/cf_tests.bash"
