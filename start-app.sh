docker run -d -p 27017:27017 -p 28017:28017 --name mongodb -v /media/data/fleetr:/data/db dockerfile/mongodb mongod --rest --httpinterface
docker run -d -p 10013:1883 --name=mqtt-broker villlem/mqtt-server:latest
docker run -d -e ROOT_URL=http://fleetr.eu -e MONGO_URL=mongodb://db:27017 -p 10025:80 --link mongodb:db --link mqtt-broker:mqtt fleetr/webui
