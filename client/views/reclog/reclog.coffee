@Logbook = new Mongo.Collection 'logbook'

MESSAGE_ROW_TYPE  = 0
START_STOP_ROW_TYPE  = 29
REGULAR_ROW_TYPE  = 30
EVENT_ROW_TYPE    = 35

UNIT_TIMEZONE = '+0200' # should be configured probably in vehicle configuration 

rowStyles =
  0: 'message-row'
  30: 'regular-row'
  29: 'start-row'
  35: 'event-row'
  'unknown' : 'unknown-row'

twin = (str1,str2) ->
  new Spacebars.SafeString(str1 + '<br>' + str2)

Template.reclog.created = ->
  @autorun ->
    Meteor.subscribe 'logbook', {}


Template.reclog.helpers
  opts: -> 
    collection: Logbook
    rowsPerPage: 50
    fields: [
      {key: 'recordTime', label: 'Time' , sort: 'descending', fn: (val,obj)-> 
        moment(val).zone(UNIT_TIMEZONE).format('DD-MM HH:mm:ss')
      }
      {key: 'type', label: 'Type'}
      # {key: 'io', label: 'IO'}
      {key: 'distance', label: 'Distance', fn: (val,obj)-> val}
      {key: 'tacho', label: 'Odo', fn: (val,obj)-> 
        km = Math.floor(val/1000)
        m = val%1000
        km + ',' + m
      }
      {key: 'speed', label: 'Speed', fn: (val,obj)-> val.toFixed(2)}
      # {key: 'startStopSpeed', label: 'Speed/Max', fn: (val,obj)-> twin(obj.startStopSpeed?.toFixed(0),obj.maxSpeed?.toFixed(0)) }
      # {key: 'startStopTravelTime', label: 'Travel time', fn: (val,obj)->
      #   diff = moment(obj.stop.recordTime).diff(moment(obj.start.recordTime), 'seconds')
      #   moment.duration(diff, "seconds").format('HH:mm:ss', {trim: false})
      # }
      # {key: 'startStopFuel', label: 'Fuel/Per 100', fn: (val,obj)->
      #   distance = (obj.stop.tacho-obj.start.tacho)/1000
      #   fuel = (obj.stop.fuelc-obj.start.fuelc)/1000
      #   twin(fuel.toFixed(2) + ' (l)', (fuel/distance*100).toFixed(2) + ' (l/100km)')
      # }
    ]
    showColumnToggles: true
    class: "table table-stripped table-hover start-stop-table"
    rowClass:(item)->
      return 'regular-row' if item.type == 30
      return 'event-row' if item.type == 35
      if item.type == 29
        return if item.io%2 == 0 then 'stop-row' else 'start-row'
      'unknown'



# createLogbookTable = () ->
#   new Tabular.Table
#     name: "Logbook"
#     collection: Logbook
#     columns: [
#       {data: 'recordTime', label: 'Time', render: (val,type,obj) -> moment(val).format('DD/MM/YYYY HH:mm:ss') }
#       {data: 'io', label: 'Start/Stop', render: (val,type,obj) ->
#         return '' if obj.type != START_STOP_ROW_TYPE
#         if val%2==0 then 'stop' else 'start'
#       }
#       {data: "type", title: "Type"}
#       {data: 'address', title: 'Location', render: (val,type,obj) -> geocode2(obj.type, obj.lat,obj.lon) }
#       {data: "speed", title: "Speed (km/h)", render: (val,type,obj) -> val }
#       {data: 'distance', title: 'Distance (m)', render: (val,type,obj) -> val}
#       {data: 'fuelUsed', title: 'Fuel (ml)', render: (val,type,obj) -> val }
#       {data: 'fuell', title: 'Fuel (l)'}  #, fn: (val,obj) -> val/1000 } }
#       {title: 'Driver', render: (val,type,obj) -> '&lt;driver&gt;' }
#       {title: 'License', render: (val,type,obj) -> '&lt;license&gt;' }
#       {title: 'Map', render: (val,type,obj) -> '&lt;map link&gt;' }
#       {data: "lat", title: "Lat", visible: false}
#       {data: "lon", title: "Lon", visible: false}
#     ]
#     # selector: () -> {type:30}


Template.logbook.rendered = ->
  #


Template.logbook.events
  'cancel.daterangepicker #daterange': (event,p) ->
    $('#daterange').val('')
    filter = Session.get(LOGBOOK_FILTER_NAME) || {}
    delete filter.recordTime
    $("#speed").val('')
    $(".aggregation-table tr").removeClass('selected')
    Session.set LOGBOOK_FILTER_NAME, filter
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(filter)
  'apply.daterangepicker #daterange': (event,p) ->
    startDate = $('#daterange').data('daterangepicker').startDate
    endDate = $('#daterange').data('daterangepicker').endDate
    console.log startDate.format('YYYY-MM-DD') + ' - ' + endDate.format('YYYY-MM-DD')
    args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
    args['$gte'] = startDate.toDate()
    $("#speed").val('')
    # args['$lte'] = endDate.add(1, 'days').toDate()
    args['$lte'] = endDate.toDate()
    Session.set LOGBOOK_FILTER_NAME, {recordTime: args}
    Session.set STARTSTOP_FILTER_NAME, {recordTime: args}
    # console.log 'logbook date filter: ' + JSON.stringify(Session.get(LOGBOOK_FILTER_NAME))
  'change #speed': (event,p) ->
    console.log 'Speed: ' + event.target.value
    filter = Session.get(STARTSTOP_FILTER_NAME) || {}
    speed = Number(event.target.value)
    filter.speed = speed
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(args)
  'click .aggregation-table tr': (event,p)->
    startDate = moment(this._id)
    endDate = moment(this._id).add(1, 'days')
    args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
    args['$gte'] = startDate.toDate()
    args['$lte'] = endDate.toDate()
    $("#speed").val('')
    # console.log 'Filter: ' + JSON.stringify(args)
    Session.set STARTSTOP_FILTER_NAME, {recordTime: args}
    $(".aggregation-table tr").removeClass('selected')
    event.currentTarget.setAttribute('class', 'selected')

  'click #hideIdleCheckbox': (event,p)->
    filter = Session.get(STARTSTOP_FILTER_NAME) || {}
    console.log 'Clicked: ' + event.target.checked
    filter.hideIdle = event.target.checked
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(args)
