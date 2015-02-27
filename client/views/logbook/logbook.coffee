sub = Meteor.subscribe 'logbook', {}

startDate = null
endDate = null

Template.logbook.helpers
  opts: ->
   collection: Logbook #.find {type: 15}
   rowsPerPage: 15
   fields: [
     { key: 'time', label: 'Time', fn: (val,obj) -> moment(val).format('MM/DD/YYYY HH:mm:ss') }
     { key: 'type', label: 'Type' }
     { key: 'lat', label: 'Latitude' }
     { key: 'lon', label: 'Longitude' }
     { key: 'speed', label: 'Speed' }
     { key: 'course', label: 'Course' }
   ]
   showColumnToggles: true
   class: "table table-bordered table-hover"

filter = () ->
    args = {}
    args['$gte'] = startDate if startDate
    args['$lte'] = endDate if endDate
    oldsub = sub
    sub = Meteor.subscribe 'logbook', {time: args} 
    oldsub.stop() if oldsub

Template.logbook.events
  # event.preventDefault();
  
  'click .reactive-table tr': (event) -> 
    alert('Click!')
  
  'changeDate #start-datepicker': (event)-> 
    console.log 'Date Changed: ' + event.date
    startDate = event.date
    filter()

  'changeDate #end-datepicker': (event)-> 
    console.log 'Date Changed: ' + event.date
    endDate = moment(event.date).add('days',1).toDate()
    console.log 'End date: ' + endDate
    filter()

Template.logbook.rendered = -> 
  $('#start-datepicker').datepicker();
  $('#end-datepicker').datepicker();
