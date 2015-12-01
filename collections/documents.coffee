@Documents = new Mongo.Collection 'documents'
Partitioner.partitionCollection Documents
Documents.attachSchema Schema.documents
