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
    if onlyUnseen
      Notifications.utils.getUnseenNotications(filter)
    else
      Notifications.utils.getAllNotications(filter)

Template.notificationsList.events
  'click .toggleSeen': (e) ->
      Session.set 'showSeenNotifications', ! Session.get('showSeenNotifications')

Template.notificationTableRow.helpers
  notificationMessage: ->
    moment.lang("bg")
    @notificationText+" на "+ moment(@expieryDate).lang("bg").format('DD-MM-YYYY')+" "
  seenIcon: ->
    if @seen
      'fa-bell-slash-o'
    else
      'fa-bell-o'
  daysToExpire: ->
    moment.lang("bg")
    moment(@expieryDate).lang("bg").from(moment())

  style: ->
      if @expieryDate < moment().add(10, 'days').toDate()
        "color:red;"
      else
        ""

Template.notificationTableRow.events
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#notifications #filter').val(tag)
    Session.set 'filterNotifications', tag
  'click .markSeen': (e) ->
    Meteor.call 'toggleNotificationSeen', @_id, @seen
