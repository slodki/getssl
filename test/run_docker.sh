#!/bin/sh

docker run -it --rm -v /home/travis/build/tslodki/getssl:/getssl $1 \
bash -c "cd /getssl/dns_scripts; CF_DOMAIN=$CF_DOMAIN CF_EMAIL=$CF_EMAIL CF_KEY=$CF_KEY ../test/cf_tests.bash"
