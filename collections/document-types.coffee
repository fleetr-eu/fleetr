@DocumentTypes = new Mongo.Collection 'documentTypes'
Partitioner.partitionCollection DocumentTypes
DocumentTypes.attachSchema Schema.documentTypes
