@DocumentTypes = new Mongo.Collection 'documentTypes'
DocumentTypes.attachSchema Schema.documentTypes
