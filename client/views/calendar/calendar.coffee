Template.calendar.helpers
  events: ->
    fc = $('.fc')
    (start, end, tz, callback) ->
      #subscribe only to specified date range
      Meteor.subscribe 'calendarEvents', start.toDate(), end.toDate(), ->
        #trigger event rendering when collection is downloaded
        fc.fullCalendar 'refetchEvents'
        return
      #find all, because we have already subscribed to a specific range
      events = CalendarEvents.find().map((it) ->
        {
          title: it.date.toISOString()
          start: it.date
          allDay: true
        }
      )
      callback events
      return
  onEventClicked: ->
    (calEvent, jsEvent, view) ->
      alert 'Event clicked: ' + calEvent.title
      return

Template.calendar.rendered = ->
  fc = @$('.fc')
  @autorun ->
    #1 trigger event re-rendering when the collection is changed in any way
    #2 find all, because we have already subscribed to a specific range
    CalendarEvents.find()
    fc.fullCalendar 'refetchEvents'
    return
  return

Template.calendar.events
  'click .addEvent': ->
    CalendarEvents.insert date: new Date
    return
  'click .removeEvent': ->
    event = CalendarEvents.findOne()
    if event
      CalendarEvents.remove event._id
    return