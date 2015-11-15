git clone --depth 1 https://chuyihuang@bitbucket.org/chuyihuang/dockerapp.git app

cd app

bundle install

bundle exec rake db:migrate

if [[ $? != 0 ]]; then
  echo
  echo "== Fail to migrate. Running setup first"
  echo
  bundle exec rake db:setup && \
  bundle exec rake db:migrate
fi

bundle exec rails server
