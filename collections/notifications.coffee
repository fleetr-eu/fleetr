@Notifications = new Mongo.Collection 'notifications'

Notifications.findFiltered = (term, unseenOnly) ->
  filter = {}
  if term
    query = term.replace ' ', '|'
    rx = $options: 'i'
    filter['$or'] = [{notificationText: _.extend(rx, {$regex: query})}, {tags: _.extend(rx, {$regex: ".*#{query}.*"})}]
  if unseenOnly then filter.seen = false
  Notifications.find filter

Notifications.getExpiringNotications = (afterDate) ->
  if afterDate
    Notifications.find {seen: false, expieryDate: {"$lte": afterDate}}, {sort: {expieryDate: 1}}
  else
    Notifications.find {seen: false}, {sort: {expieryDate: 1}}
