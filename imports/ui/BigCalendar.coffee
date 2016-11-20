BigCalendar = require 'react-big-calendar'
{ createContainer } = require 'meteor/react-meteor-data'

module.exports = createContainer (props) ->
  events: CustomEvents.find {},
    transform: (doc) ->
      title: doc.name,
      start: doc.date,
      end: doc.date,
      allDay: true
, BigCalendar
