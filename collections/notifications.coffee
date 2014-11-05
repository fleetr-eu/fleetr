@Notifications = new Mongo.Collection 'notifications'

Notifications.utils =
  getUnseenNotications: (filter) ->
    if filter
      Notifications.find {seen: false, $or: [{notificationText: filter}, {tags: {$regex : ".*"+filter+".*"}}]}
    else
      Notifications.find {seen: false}

  getAllNotications: (filter) ->
    if filter
      Notifications.find {$or: [{notificationText: filter}, {tags: {$regex : ".*"+filter+".*"}}]}
    else
      Notifications.find {},

  getExpiringNotications: (afterDate) ->
    if afterDate
      Notifications.find {seen: false, expieryDate: {"$lte": afterDate}}, {sort: {expieryDate: 1}}
    else
      Notifications.find {seen: false}, {sort: {expieryDate: 1}}
