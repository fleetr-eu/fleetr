@Notifications = new Mongo.Collection 'notifications'

Notifications.utils =
  getUnseenNotications: (filter) ->
    if filter
      Notifications.find {seen: false, $or: [{notificationText: filter}, {tags: {$elemMatch: filter}}]}, {sort: {expieryDate: 1}}
    else
      Notifications.find {seen: false}, {sort: {expieryDate: 1}}

  getAllNotications: (filter) ->
    if filter
      Notifications.find {$or: [{notificationText: filter}, {tags: {$elemMatch: filter}}]}, {sort: {expieryDate: 1}}
    else
      Notifications.find {}, {sort: {expieryDate: 1}}

  getExpiringNotications: (afterDate) ->
    if afterDate
      Notifications.find {seen:false, expieryDate: {"$lte": afterDate}}, {sort: {expieryDate: 1}}
    else
      Notifications.find {seen: false}, {sort: {expieryDate: 1}}
