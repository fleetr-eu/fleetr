@Notifications = new Mongo.Collection 'notifications'

Notifications.daysToExpireStyle = (expieryDate) ->

  if expieryDate < moment().add(2, 'days').toDate()
    "color:red;"
  else
    if expieryDate < moment().add(5, 'days').toDate()
      "color:orange;"
    else
      "color:navy;"

Notifications.findFiltered = (term, unseenOnly) ->
  filter = {}
  if term
    query = term.replace ' ', '|'
    rx =
      $options: 'i'
      $regex: query
    filter['$or'] = [{notificationText: rx}, {tags: rx}]
  if unseenOnly then filter.seen = false
  Notifications.find filter

Notifications.getExpiringNotications = (afterDate) ->
  afterDate = moment().add(10, 'days').toDate()
  Notifications.find {seen: false, expieryDate: {$lte: new Date(afterDate)}}, {sort: {expieryDate: 1}, }
