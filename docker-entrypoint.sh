git clone --depth 1 https://github.com/chuyihuang/dockerapp.git app
# git clone --depth 1 ~/repository/dockerapp.git dockerapp
# git clone https://github.com/chuyihuang/dockerapp.git 

cd dockerapp

source "/usr/local/share/chruby/chruby.sh"

chruby ruby

gem install bundler

bundle install --without=development,test

bundle exec rake db:migrate

if [[ $? != 0 ]]; then
  echo
  echo "== Fail to migrate. Running setup first"
  echo
  bundle exec rake db:setup && \
  bundle exec rake db:migrate
fi

export SECRET_KEY_BASE=$(rake secret)

sudo rm /etc/nginx/sites-enabled/*
sudo ln -s /home/app/nginx.conf /etc/nginx/sites-enabled/app.conf

sudo service nginx start

bundle exec rake assets:clean assets:precompile

bundle exec puma -e production -b unix:///home/app/puma.sock
