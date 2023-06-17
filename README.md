# The working of the webapp
### Flask backend app which servers apis with post, get, put, delete methods used to read,create,update and delete the records ( book name,author,price ) in the mysql database. It needs MYSQL to be there and for connection flask app consumes an environment variable 
```sh
DEV_DATABASE_URL=mysql+pymysql://username:password@hostnameofsql:postofthecontainer/databasename
```
### and connects to database to create,read,update and delete.
---
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
## The approach I used to configure  the web application to talk to the database in K8s .
### I created statefulset for the database pods and exposed the pods which have have selector 
```sh
app: sql-app
```
### with a clusterip, so that the service will acts as hostname for the sql pods and flask can use that service name as host to connect database.
---
## The approach I used to configure the autoscaling 
### I used hpa which is horizontal pod autoscaler which monitors the health of the Deployment and scales in or scales out pods in the dpeloyment by adding/removing the replica.
### In this repo I created hpa for the flask-app-deployment, while creating deployment I set cpu metrics to allocate for the pods and limits as well. Based on the resources allocated to pods if it reaches 50% ( as per my configuration ) in terms of CPU utilization hpa scales by adding more replicas.
---
## The approach I used expose the web application in K8s to outside world
### I created deployment for the flask_app and exposed the deployment pods which have selector 
```sh
pp: flask-app
```
### so that the service will creates port in the k8s host in this case minikube node which is accessible via networking to the outside world which will be outside of cluster, and by using the minikube ip and the port number we defined in the nodeport ( in this case 30000 I defined ) url format will be like :-  http://minikubeip:30000
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
