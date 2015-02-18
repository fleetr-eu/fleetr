docker run -d -p 27017:27017 -p 28017:28017 --name mongodb -v /home/babbata/workspace/data:/data/db dockerfile/mongodb mongod --rest --httpinterface
