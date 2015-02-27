Template.logbook.helpers
  opts: ->
   collection: Logbook
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

Template.logbook.events
  # event.preventDefault();
  'click .reactive-table tr': (event) -> alert('Click!')
  'changeDate #my-datepicker' : (event)-> console.log '!!! Date Changed: ' + event.date


Template.logbook.rendered=() -> $('#my-datepicker').datepicker();
