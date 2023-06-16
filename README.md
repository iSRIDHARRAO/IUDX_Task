## This repo consists of the webapp ( which can accept get , post , put, delete requests) and the manifest files to deploy into Docker( by using Docker commands and docker-compose file ) and Kubernetes.
 ### _Note :- After deploying access the "/" path first otherwise will get table error_
### Steps to clone the repo
```sh
git clone https://github.com/iSRIDHARRAO/IUDX_Task.git
cd IUDX_Task
```
#
---
### Steps to deploy in docker by using docker adhoc commands
```sh
 cd docker
 ./run_in_docker.sh
``` 
##### The bash script will automatically build the image and deploys into Docker.
#
---
### Steps to deploy in docker using docker-compose

```sh
cd docker_compose
./build_image.sh
```
##### The bash script will automatically build the image and deploys into Docker using docker-compose plugin.
#
---
### Steps to deploy in docker using docker-compose

### _(Optional)_ To enable the metric server add-on in minikube
```sh
minikube addons enable metrics-server
```

##### Considering kubectl is already available in the Operating System and considering minikube for k8s cluster.
#
```sh
cd k8s
kubectl apply -f database_pv.yml
kubectl apply -f database_statefulset_mysql.yml
kubectl apply -f database_clusterip.yml
kubectl apply -f flask_app_deployment.yml
kubectl apply -f flask_app_nodeport.yml
kubectl apply -f deployment_hpa.yml
```
### The web app will be accessible using minikubeip:30000  
---
#### The apis available for the web app are as follows

| path | request-type | response | curl command example |
|------|:------------:|:----------:|--------------------|
|  /   |   GET        | Creates the table initially in the database | curl http://minikubeip:30000/ |
| /book/list| GET | Returns all the books from the table | curl http://minikubeip:30000/book/list  |
| /book | POST |Creates a new book entry in the table |curl -H "Content-Type: application/json" -X POST -d '{"title": "Learning", "author": "Ibrahim","price": "3.44"}' http://minikubeip:30000/book {"author": "Ibrahim", "isbn": 3, "price": 3.44, "title":"Learning"} |
|/book/int|PUT|Updates the existing record( book ) in the table based on the given id |curl http://minikubeip:30000/book/3 -X PUT -H "Content-Type: application/json" -d '{"author": "Ahmed", "title": "Python for Beginners", "price": 12.99}'{"author": "Ahmed", "isbn": 3, "price": 12.99, "title": "Python for Beginners"}|
|/book/int|DELETE|Deletes the book with the given id|curl http://minikube:30000/book/2 -X DELETE {"result": true} |
## To access application when deployed in docker need to use the system ip or localhost and port number 5000
