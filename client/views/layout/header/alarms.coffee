Template.headerAlarms.helpers
  unseenAlarms: -> if Session.get('snoozed') then [] else Alarms.find({seen:false}, {$sort: {timestamp: -1}, limit:4})
  unseenAlarmsCount: -> if Session.get('snoozed') then 0 else Alarms.find({seen:false}).count()
  unseenAlarmsExist: -> if Session.get('snoozed') then false else Alarms.find({seen:false}).count() > 0
  alarmSnoozeText: ->
    if Session.get('snoozed') then 'Включи аларми' else 'Изключи аларми'
  alarmSnoozeImageSrc: ->
    if Session.get('snoozed') then '/images/notification-snoozed.png' else '/images/notification.png'
  alarmSnoozeActionImageSrc: ->
      if Session.get('snoozed') then '/images/notification.png' else '/images/notification-snoozed.png' 

Template.headerAlarm.helpers
  timeAgo: -> moment(@timestamp).from(moment.utc())
  style: -> Alarms.timeAgoStyle(@timestamp)
  alarmText: -> @description

Template.headerAlarms.events
  'click .snooze': (event, tpl) ->
    Session.set('snoozed', !Session.get('snoozed'))
