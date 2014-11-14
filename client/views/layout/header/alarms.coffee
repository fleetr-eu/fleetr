Template.alarms.helpers
  unseenAlarms: -> Alarms.find({seen:false}, {$sort: {timestamp: -1}})

  unseenAlarmsCount: ->
    alarms = Alarms.find({seen:false})
    alarms?.count()

  unseenAlarmsExist: ->
    alarms = Alarms.find({seen:false})
    alarms?.count() > 0

Template.alarm.helpers
  alarmText: -> Alarms.alarmText(@)
  timeAgo: -> moment(@timestamp).from(moment())
  style: -> Alarms.timeAgoStyle(@timestamp)
