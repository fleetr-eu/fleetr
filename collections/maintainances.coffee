@Maintenances = new Mongo.Collection 'maintenances'
Maintenances.attachSchema Schema.maintenances


Maintenances.after.update (userId, doc, fieldNames, modifier, options) ->
   if doc.nextMaintenanceDate
   	maintenanceType = MaintenanceTypes.findOne {_id: doc.maintenanceType}
   	maintenanceName = maintenanceType?.name
    event = CustomEvents.findOne { sourceId: doc._id }
    if event
      CustomEvents.update(event._id, { $set: { date: doc.nextMaintenanceDate, name: "Поддръжка: " + maintenanceName}} )
    else
      CustomEvents.insert
        sourceId: doc._id
        name: "Поддръжка: " + maintenanceName
        kind: "Поддръжка"
        date: doc.nextMaintenanceDate
        vehicleId: doc.vehicle
        active: true
        seen: false

Maintenances.after.insert (userId, doc) ->
  if doc.nextMaintenanceDate
  	maintenanceType = MaintenanceTypes.findOne {_id: doc.maintenanceType}
  	maintenanceName = maintenanceType?.name
  	CustomEvents.insert
      sourceId: doc._id
      name: "Поддръжка: " + maintenanceName
      kind: "Поддръжка"
      date: doc.nextMaintenanceDate
      vehicleId: doc.vehicle
      active: true
      seen: false
