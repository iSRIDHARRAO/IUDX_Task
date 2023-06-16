docker images | grep flask_app_api > /dev/null

if [[ $? != 0 ]]; then docker build -t flask_app_api ../crud_api; fi

docker-compose up  -d