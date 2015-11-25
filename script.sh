db() {
  # docker run -P --volumes-from app_data --name app_db -e POSTGRES_USER=app_user -e POSTGRES_PASSWORD=$APP_PWD -d -t postgres:latest
  # docker run -e POSTGRES_USER=app_user -e POSTGRES_PASSWORD=$APP_PWD -d -t postgres:latest
  docker run -P --volumes-from app_data --name mysql -e MYSQL_ROOT_PASSWORD=aabbcc -d -t mysql:latest
}

app() {
  docker stop app
  docker rm app
  docker run -d -p 80:80 --name app --link mysql:latest chu/app
  # docker run -p 80:80 --link app_db:postgres --name app chu/app
}

action=$1

${action}
