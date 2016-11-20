{ createContainer } = require 'meteor/react-meteor-data'
BigCalendar = require 'react-big-calendar'
styles = require 'react-big-calendar/lib/css/react-big-calendar.css'

BigCalendar.momentLocalizer(require 'moment')
module.exports = createContainer (props) ->
  console.log props
  timeslots: 1
  onSelectEvent: props.onSelectEvent
  views: ['month', 'agenda']
  events: CustomEvents.find().fetch().map (doc) ->
    id: doc._id
    title: doc.name,
    start: doc.date,
    end: doc.date,
    allDay: true
, BigCalendar
