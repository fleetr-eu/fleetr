Template.notificationsList.helpers
  notifications: ->
    filter =
      $regex: "#{Session.get('filterNotifications').trim()}".replace ' ', '|'
      $options: 'i'
    Notifications.find {notificationText: filter}

Template.notificationTableRow.helpers
  notificationMessage: -> @notificationText+" "+ @expieryDate.toLocaleDateString()
