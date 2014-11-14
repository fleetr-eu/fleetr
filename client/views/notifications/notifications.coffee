Template.notificationsList.created = -> Session.set 'filterNotifications', ''

Template.notificationsList.helpers
  toggleSeenIcon: ->
    if Session.get('showSeenNotifications')
      'fa-bell'
    else
      'fa-bell-slash'
  notifications: ->
    Notifications.findFiltered(Session.get('filterNotifications').trim(), Session.get('showSeenNotifications'))

Template.notificationsList.events
  'click .toggleSeen': (e) ->
      Session.set 'showSeenNotifications', ! Session.get('showSeenNotifications')

Template.notificationTableRow.helpers
  notificationMessage: ->
    @notificationText+" на "+ moment(@expieryDate).locale(Settings.locale).format(Settings.longDateFormat)+" "
  seenIcon: ->
    if @seen
      'fa-bell-slash-o'
    else
      'fa-bell-o'
  daysToExpire: ->
    moment(@expieryDate).locale(Settings.locale).from(moment())

  style: -> Notifications.daysToExpireStyle(@expieryDate)
  tagsArray: -> @tags?.split(",") || []


Template.notificationTableRow.events
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#notifications #filter').val(tag)
    Session.set 'filterNotifications', tag
  'click .markSeen': (e) ->
    Meteor.call 'toggleNotificationSeen', @_id, @seen
