Template.logbook.created = ->
  @autorun -> Meteor.subscribe 'logbook', Session.get('logbook date filter')

Template.logbook.rendered = -> $('.datepicker').datepicker()

Template.logbook.helpers
  opts: ->
   collection: Logbook #.find {type: 15}
   rowsPerPage: 15
   fields: [
     { key: 'time', label: 'Time', fn: (val,obj) -> moment(val).format('DD/MM/YYYY HH:mm:ss') }
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

  'click .reactive-table tr': (event) ->
    alert('Click!')

  'changeDate .datepicker': (event) ->
    args = Session.get('logbook date filter')?.time || {}
    args['$gte'] = event.date if event.target.id == 'start-datepicker'
    args['$lte'] = moment(event.date).add(1, 'days').toDate() if event.target.id == 'end-datepicker'
    Session.set 'logbook date filter', {time: args}
