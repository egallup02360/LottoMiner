#!/usr/bin/env bash

cd /root/LottoMiner
git pull
rbenv exec bundle exec bundle install
yarn install
rbenv exec bundle exec rails assets:precompile
rbenv exec bundle exec rails webpacker:compile
service lottominer-web restart
