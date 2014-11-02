
Template.drivers.events
  'click .deleteDriver': -> Meteor.call 'removeDriver', @_id
  'keyup input.search-query': -> Session.set 'filterDrivers', $('#filterDrivers').val()

Template.drivers.helpers
  drivers: ->
    filter =
      $regex: "#{Session.get('filterDrivers').trim()}".replace ' ', '|'
      $options: 'i'
    Drivers.find $or: [{name: filter}, {firstName: filter}]
  search: -> Session.get('filterDrivers')

Template.driverTableRow.helpers
  fullName: -> "#{@firstName || ''} #{@name || ''}"
  licenseCats: ->
    if @categories
      (@categories.map (cat) -> cat.license).toString()
    else ''
  unseenNotificationsMessage: ->
    count = Notifications.find({source:@_id, seen:false}).count()
    if count == 1
      "Има 1 невидяно напомняне свързано с този шофьор"
    else
      "Има #{count} невидяни напомняния свързано с този шофьор"

  hasUnseenNotifications: ->
    Notifications.find({source:@_id, seen:false}).count() > 0
