#!/bin/bash
CUR_DIR=${PWD}
exec /bin/bash << 'EOT'
  source /home/ubuntu/.rvm/scripts/rvm

  cd "$CUR_DIR"
  git pull origin master
  rm -f sidekiq.log
  rm -rf tmp
  mkdir tmp

  exec bundle install
EOT