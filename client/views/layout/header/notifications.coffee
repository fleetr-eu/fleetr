Template.notifications.helpers
  unseenNotifications: -> Notifications.getExpiringNotications()
  unseenNotificationsCount: -> Notifications.getExpiringNotications().count()
  unseenNotificationsExist: -> Notifications.getExpiringNotications().count() > 0

Template.notification.helpers
  formatedExpieryDate: -> @expieryDate.toLocaleDateString()
  daysToExpire: -> moment(@expieryDate).locale(Settings.locale).from(moment())
  style: -> Notifications.daysToExpireStyle(@expieryDate)
