Template.headerAlarms.helpers
  unseenAlarms: -> Alarms.find({seen:false}, {$sort: {timestamp: -1}, limit:4})

  unseenAlarmsCount: -> Alarms.find({seen:false}).count()

  unseenAlarmsExist: -> Alarms.find({seen:false}).count() > 0

Template.headerAlarm.helpers
  timeAgo: -> moment(@timestamp).from(moment())
  style: -> Alarms.timeAgoStyle(@timestamp)
  alarmText: -> @description
