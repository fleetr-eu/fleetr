@Documents = new Mongo.Collection 'documents'
Partitioner.partitionCollection Documents
Documents.attachSchema Schema.documents

Documents.after.update (userId, doc, fieldNames, modifier, options) ->
   if doc.validTo
   	documentType = DocumentTypes.findOne {_id: doc.type}
   	documentName = documentType?.name
    event = CustomEvents.findOne { sourceId: doc._id }
    if event 
      CustomEvents.update(event._id, { $set: { date: doc.validTo, name: "Документ: " + documentName}} )
    else
      CustomEvents.insert
        sourceId: doc._id
        name: "Документ: " + documentName
        kind: "Документ"
        date: doc.validTo
        driverId: doc.driverId
        active: true
        seen: false

Documents.after.insert (userId, doc) ->
  if doc.validTo
   	documentType = DocumentTypes.findOne {_id: doc.type}
   	documentName = documentType?.name
  	CustomEvents.insert
      sourceId: doc._id
      name: "Документ: " + documentName
      kind: "Документ"
      date: doc.validTo
      driverId: doc.driverId
      active: true
      seen: false