Template.alarms.helpers
  unseenAlarms: ->
    Alarms.find ({seen:false})

  unseenAlarmsCount: ->
    alarms = Alarms.find ({seen:false})
    if alarms
      alarms.count()

  unseenAlarmsExist: ->
    alarms = Alarms.find ({seen:false})
    if alarms
      alarms.count() > 0

Template.alarm.helpers
  alarmText: -> Alarms.alarmText(@)

  timeElapsed: ->
    moment(@timestamp).from(moment())
