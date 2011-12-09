#!/bin/sh

sudo apt-get update
sudo apt-get install -y git-core

rm -Rf defuzeme
git clone bigbourin@git.rootbox.fr:defuzeme.git

sudo apt-get install -y ruby1.8 rubygems1.8 postgresql-server-dev-8.4 mysql-server sqlite3 libsqlite3-dev rake libmysql-ruby1.8 libmysqlclient-dev

export PATH="$PATH:/var/lib/gems/1.8/bin"

cd defuzeme
sudo gem install --no-rdoc --no-ri rake bundler

cat <<EOF >> Gemfile
#gem 'mysql2'
gem 'sqlite3'
EOF

bundle install

cat <<EOF > config/database.yml
development:
  adapter: postgresql
  database: defuzeme_dev

mysql:
  adapter: mysql
  username: root
  password: eipbilantech
  database: defuzeme_dev

sqlite:
  adapter: sqlite3
  database: db/defuzeme_dev

test:
  adapter: postgresql
  database: defuzeme_test
EOF

sudo -u postgres createuser -s labeip

bundle exec rake db:create
bundle exec RAILS_ENV=mysql rake db:create
bundle exec RAILS_ENV=sqlite rake db:create
bundle exec rake db:migrate
bundle exec RAILS_ENV=mysql rake db:migrate
bundle exec RAILS_ENV=sqlite rake db:migrate
bundle exec rake db:seed
bundle exec RAILS_ENV=mysql rake db:seed
bundle exec RAILS_ENV=sqlite rake db:seed

killall thin

bundle exec thin start -e development -d -p 3000 --pid tmp/pids/thin0.pid
bundle exec RAILS_ENV=mysql thin start -e mysql -d -p 3001 --pid tmp/pids/thin1.pid
bundle exec RAILS_ENV=sqlite thin start -e sqlite -d -p 3002 --pid tmp/pids/thin2.pid
