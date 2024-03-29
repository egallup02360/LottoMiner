#!/usr/bin/env bash

# Optional step - it takes couple of seconds (or longer) to establish a WiFi connection
# sometimes. In this case, following checks will fail and wifi-connect
# will be launched even if the device will be able to connect to a WiFi network.
# If this is your case, you can wait for a while and then check for the connection.
sleep 30

wget --spider http://google.com 2>&1

if [ $? -eq 0 ]; then
    printf 'Skipping WiFi Connect\n'
else
    printf 'Starting WiFi Connect\n'
    service lottominer-web stop
    sleep 3
    wifi-connect -s LottoMiner-Config
fi

crontab -l | echo "0 0 * * * /root/LottoMiner/update_lottominer.sh" | crontab -

FILE=/root/cgminer.conf
if [ ! -f "$FILE" ]; then
  cp /root/LottoMiner/cgminer.conf /root/cgminer.conf
  service cgminer restart
fi

# Start your application here.
cd /root/LottoMiner
git pull
rbenv exec bundle exec bundle install
yarn install
rbenv exec bundle exec rails assets:precompile
rbenv exec bundle exec rails webpacker:compile
service lottominer-web restart
FILE=/root/LottoMiner/LEDS_OFF
if [ ! -f "$FILE" ]; then
  service leds start
fi
