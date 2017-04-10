@Drivers = new Mongo.Collection 'drivers'
Drivers.getAssignedVechicle =  (driver, timestamp) ->
  dvAssignment = DriverVehicleAssignments.findOne {driver:driver},  {sort: {moment: -1}}
  if (dvAssignment?.moment <= timestamp) and (dvAssignment?.event=='begin')
    dvAssignment.vehicle
  else
    ""

Drivers.helpers
  fullName: ->
    "#{@firstName} #{@name}"

Drivers.utils =
  processNotifications: (doc, id) ->
    if doc.validTo
      Notifications.insert {
        source:id,
        notificationText:"Документът за самоличност на #{doc.firstName} #{doc.name} изтича ",
        expieryDate: doc.validTo,
        tags:'документ,шофьор',
        seen:false
      }
    if doc.licenseExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Свидетелството за управление на #{doc.firstName} #{doc.name} изтича ",
        expieryDate: doc.licenseExpieryDate,
        tags:'свидетелство,шофьор',
        seen:false
      }
    if doc.medEvalExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Медицинското свидетелство на #{doc.firstName} #{doc.name} изтича ",
        expieryDate: doc.medEvalExpieryDate,
        tags:'свидетелство,шофьор',
        seen:false
      }
    if doc.profCertExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Професионаленият сертификат на #{doc.firstName} #{doc.name} изтича ",
        expieryDate: doc.profCertExpieryDate,
        tags:'сертификат,шофьор',
        seen:false
      }
    if doc.psychApprovalExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Удостоверението за психологическа годност на #{doc.firstName} #{doc.name} изтича ",
        expieryDate: doc.psychApprovalExpieryDate,
        tags:'удостоверение,шофьор',
        seen:false
      }

Drivers.attachSchema Schema.driver

Drivers.before.insert (userId, doc) ->
  doc.timestamp ?= Date.now()

Drivers.after.update (userId, doc, fieldNames, modifier, options) ->
  if doc._id
    Notifications.remove {source:doc._id}
  Drivers.utils.processNotifications doc, doc._id

Drivers.after.insert (userId, doc) ->
  Drivers.utils.processNotifications doc, @_id

Drivers.after.remove (userId, doc) ->
  if doc._id
    Notifications.remove {source:doc._id}
