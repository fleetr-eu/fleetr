@Drivers = new Mongo.Collection 'drivers'

Drivers.attachSchema Schema.driver

Drivers.before.insert (userId, doc) ->
  doc.timestamp ?= Date.now()
  if doc.validTo
    Notifications.insert {notificationText:"Документ за  самоличност на #{doc.firstName} #{doc.name} изтича на ", expieryDate: doc.validTo, seen:false}
  if doc.licenseExpieryDate
    Notifications.insert {notificationText:"Свидетелство за управление на #{doc.firstName} #{doc.name} изтича на ", expieryDate: doc.licenseExpieryDate, seen:false}
