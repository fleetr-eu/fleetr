@CalendarEvents = new Mongo.Collection 'calendarEvents'
Partitioner.partitionCollection CalendarEvents
#CalendarEvents.attachSchema Schema.calendarEvents
