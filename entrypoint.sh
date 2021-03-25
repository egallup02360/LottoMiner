#!/usr/bin/env bash

# Optional step - it takes couple of seconds (or longer) to establish a WiFi connection
# sometimes. In this case, following checks will fail and wifi-connect
# will be launched even if the device will be able to connect to a WiFi network.
# If this is your case, you can wait for a while and then check for the connection.
wifi-connect --help 2>&1
if [ $? -ne 0 ]; then
    bash <(curl -L https://github.com/balena-io/wifi-connect/raw/master/scripts/raspbian-install.sh)
fi

#sleep 15

wget --spider http://google.com 2>&1

if [ $? -eq 0 ]; then
    printf 'Skipping WiFi Connect\n'
else
    printf 'Starting WiFi Connect\n'
    wifi-connect -s LottoMiner-Config
fi

# Start your application here.
cd /root/LottoMiner
git pull
rbenv exec bundle exec bundle install
yarn install
rbenv exec bundle exec rails assets:precompile
rbenv exec bundle exec rails webpacker:compile
rbenv exec bundle exec rails s -e production -p 80
