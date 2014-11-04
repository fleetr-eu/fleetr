@Drivers = new Mongo.Collection 'drivers'

Drivers.utils =
  processNotifications: (doc, id) ->
    if doc.validTo
      Notifications.insert {
        source:id,
        notificationText:"Документът за самоличност на #{doc.firstName} #{doc.name} изтича на ",
        expieryDate: doc.validTo,
        tags:['документ', 'шофьор'],
        seen:false
      }
    if doc.licenseExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Свидетелството за управление на #{doc.firstName} #{doc.name} изтича на ",
        expieryDate: doc.licenseExpieryDate,
        tags:['свидетелство', 'шофьор'],
        seen:false
      }
    if doc.medEvalExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Медицинското свидетелство на #{doc.firstName} #{doc.name} изтича на ",
        expieryDate: doc.medEvalExpieryDate,
        tags:['свидетелство', 'шофьор'],
        seen:false
      }
    if doc.profCertExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Професионаленият сертификат на #{doc.firstName} #{doc.name} изтича на ",
        expieryDate: doc.profCertExpieryDate,
        tags:['сертификат', 'шофьор'],
        seen:false
      }
    if doc.psychApprovalExpieryDate
      Notifications.insert {
        source:id,
        notificationText:"Удостоверението за психологическа годност на #{doc.firstName} #{doc.name} изтича на ",
        expieryDate: doc.psychApprovalExpieryDate,
        tags:['удостоверение', 'шофьор'],
        seen:false
      }

Drivers.attachSchema Schema.driver

Drivers.allow
  insert: -> true
  update: -> true
  remove: -> true

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
