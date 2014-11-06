Template.notifications.helpers
  unseenNotifications: ->
    Notifications.getExpiringNotications(moment().add(10, 'days').toDate())

  unseenNotificationsCount: ->
    Notifications.getExpiringNotications(moment().add(10, 'days').toDate()).count()

  unseenNotificationsExist: ->
    Notifications.getExpiringNotications(moment().add(10, 'days').toDate()).count() > 0

Template.notification.helpers
  formatedExpieryDate: ->
    @expieryDate.toLocaleDateString()

  daysToExpire: ->
    moment(@expieryDate).from(moment())
