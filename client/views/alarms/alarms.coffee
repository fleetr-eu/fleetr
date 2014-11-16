Template.alarmsList.created = -> Session.set 'filterAlarms', ''

Template.alarmsList.helpers
  toggleSeenIcon: ->
    if Session.get('showSeenAlarms')
      'fa-bell'
    else
      'fa-bell-slash'
  alarms: ->
    Alarms.findFiltered(Session.get('filterAlarms').trim(), Session.get('showSeenAlarms'))

Template.alarmsList.events
  'click .toggleSeen': (e) ->
      Session.set 'showSeenAlarms', ! Session.get('showSeenAlarms')

Template.alarmTableRow.helpers

  seenIcon: ->
    if @seen
      'fa-bell-slash-o'
    else
      'fa-bell-o'

  timeAgo: -> moment(@timestamp).locale(Settings.locale).from(moment())

  tagsArray: ->
    if @tags
      @tags.split(",")
    else
      []

  style: -> Alarms.timeAgoStyle(@timestamp)

Template.alarmTableRow.events
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#alarms #filter').val(tag)
    Session.set 'filterAlarms', tag
  'click .markSeen': (e) ->
    Meteor.call 'toggleAlarmSeen', @_id, @seen
