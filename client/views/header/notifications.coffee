Template.notifications.helpers
  unseenNotifications: ->
    Notifications.utils.getExpiringNotications(moment().add(10, 'days').toDate())

  unseenNotificationsCount: ->
    Notifications.utils.getExpiringNotications(moment().add(10, 'days').toDate()).count()

  unseenNotificationsExist: ->
    Notifications.utils.getExpiringNotications(moment().add(10, 'days').toDate()).count() > 0

Template.notification.helpers
  formatedExpieryDate: ->
    @expieryDate.toLocaleDateString()

  daysToExpire: ->
    moment(@expieryDate).from(moment())
