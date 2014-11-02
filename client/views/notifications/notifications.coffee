Template.notificationsList.helpers
  toggleSeenIcon: ->
    if Session.get('showSeenNotifications')
      'fa-bell'
    else
      'fa-bell-slash'
  notifications: ->
    onlyUnseen = Session.get('showSeenNotifications')
    q = Session.get('filterNotifications').trim()
    filter =
      $regex: q.replace ' ', '|'
      $options: 'i'
    if !onlyUnseen
      Notifications.find {$and: [{seen:false}, $or: [{notificationText: filter}, {tags: {$elemMatch: filter}}]]}
    else
      Notifications.find { $or: [{notificationText: filter}, {tags: {$elemMatch: filter}}]}


Template.notificationsList.events
  'click .toggleSeen': (e) ->
      Session.set 'showSeenNotifications', ! Session.get('showSeenNotifications')

Template.notificationTableRow.helpers
  notificationMessage: -> @notificationText+" "+ @expieryDate.toLocaleDateString()
  seenIcon: ->
    if @seen
      'fa-bell-slash-o'
    else
      'fa-bell-o'

Template.notificationTableRow.events
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#notifications #filter').val(tag)
    Session.set 'filterNotifications', tag
  'click .markSeen': (e) ->
    Meteor.call 'toggleNotificationSeen', @_id, @seen
