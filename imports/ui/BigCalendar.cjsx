{ createContainer } = require 'meteor/react-meteor-data'
BigCalendar = require 'react-big-calendar'
styles = require 'react-big-calendar/lib/css/react-big-calendar.css'

module.exports = createContainer (props) ->
  setLocalizer:
    BigCalendar.momentLocalizer(require 'moment')
  timeslots: 1
  popup: true
  selectable: true
  onSelectEvent: props.onSelectEvent
  onSelectSlot: props.onSelectSlot
  views: ['month', 'week', 'day']
  formats:
    agendaDateFormat: "DD.MM.YYYY"
  events: CustomEvents.find().fetch().map (doc) ->
    id: doc._id
    title: doc.name,
    start: doc.date,
    end: doc.date,
    allDay: true
  messages:
    allDay: 'цял ден'
    previous: 'преден'
    next: 'следващ'
    today: 'днес'
    month: 'месец'
    week: 'седмица'
    day: 'ден'
    agenda: 'списък'
, BigCalendar
