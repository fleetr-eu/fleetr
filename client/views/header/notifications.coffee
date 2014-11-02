Template.notifications.helpers
  unseenNotifications: -> Notifications.find({seen:false})
  unseenNotificationsCount: -> Notifications.find({seen:false}).count()
  unseenNotificationsExist: -> Notifications.find({seen:false}).count() > 0

Template.notification.helpers
  formatedExpieryDate: ->
    @expieryDate.toLocaleDateString()
