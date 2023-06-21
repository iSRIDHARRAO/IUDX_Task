docker images | grep flask_app_api > /dev/null

if [[ $? != 0 ]]; then docker build -t flask_app_api ../crud_api; fi


docker network create iudx

docker volume create iudx_data

docker run --name sql_container --network=iudx  -v  iudx_data:/var/lib/mysql -e MYSQL_DATABASE=iudx -e MYSQL_USER=sqluser -e MYSQL_PASSWORD=sqlpassword -e MYSQL_ROOT_PASSWORD=root -d mysql:latest

docker run -d --name flask_app -e DEV_DATABASE_URL=mysql+pymysql://sqluser:sqlpassword@sql_container:3306/iudx -e FLASK_APP=bookshop.py --network=iudx -p 5000:5000 flask_app_api
