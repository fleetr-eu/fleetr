# @DateRangeAggregation = new Mongo.Collection 'dateRangeAggregation'
# # @StartStop = new Mongo.Collection 'startstop'
#
# LOGBOOK_FILTER_NAME   = 'logbook-filter'
# STARTSTOP_FILTER_NAME = 'logbook-startstop-filter'
#
# MESSAGE_ROW_TYPE  = 0
# START_STOP_ROW_TYPE  = 29
# REGULAR_ROW_TYPE  = 30
# EVENT_ROW_TYPE    = 35
#
# twin = (str1, str2) ->
#   new Spacebars.SafeString(str1 + '<br>' + str2)
#
# Template.mapCellTemplate.helpers
#   opts: -> encodeURIComponent EJSON.stringify
#     deviceId: @start.deviceId
#     start:
#       time: moment(@start.recordTime).valueOf()
#       position:
#         lat: @start.lat
#         lng: @start.lon
#     stop:
#       time: moment(@stop.recordTime).valueOf()
#       position:
#         lat: @stop.lat
#         lng: @stop.lon
#
# Template.logbook.created = ->
#   @autorun ->
#     Meteor.subscribe 'dateRangeAggregation', Session.get(LOGBOOK_FILTER_NAME)
#     # Meteor.subscribe 'startstop', Session.get(STARTSTOP_FILTER_NAME)
#
# Template.logbook.rendered = ->
#
#   drp = '<label>Period:<input type="text" id="daterange" class="form-control input-sm"/>  </label> '
#   $("#aggregated-table-section").find("#datatable_length").parent().removeClass("col-sm-6")
#   $("#aggregated-table-section").find("#datatable_filter").parent().removeClass("col-sm-6")
#   $("#aggregated-table-section").find("#datatable_length").parent().addClass("col-sm-4")
#   $("#aggregated-table-section").find("#datatable_filter").parent().addClass("col-sm-8")
#   $("#aggregated-table-section").find("#datatable_filter").prepend(drp)
#
#   sp = '<label>Speed:<input type="text" id="speed" class="form-control input-sm"/>  </label>
#         <label>Hide Idle <input id="hideIdleCheckbox" type="checkbox" class="form-control hide-idle" />&nbsp;&nbsp;</label>'
#   $("#detailed-table-section").find("#datatable_length").parent().removeClass("col-sm-6")
#   $("#detailed-table-section").find("#datatable_filter").parent().removeClass("col-sm-6")
#   $("#detailed-table-section").find("#datatable_length").parent().addClass("col-sm-4")
#   $("#detailed-table-section").find("#datatable_filter").parent().addClass("col-sm-8")
#   $("#detailed-table-section").find("#datatable_filter").prepend(sp)
#
#
#   $('#daterange').daterangepicker
#     locale: {cancelLabel: 'Clear'}
#     ranges:
#       'Today': [moment(), moment()]
#       'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')]
#       'Last 7 Days': [moment().subtract(6, 'days'), moment()]
#       'Last 30 Days': [moment().subtract(29, 'days'), moment()]
#       'This Month': [moment().startOf('month'), moment().endOf('month')]
#       'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
#
# geocode2 = (type, lat, lon) ->
#   return "" if type == MESSAGE_ROW_TYPE
#   scale = 1000
#   lat = Math.round(lat*scale)
#   lon = Math.round(lon*scale)
#
#   code = MyCodes.findCachedLocationName lat, lon
#
#   if code
#     return code.address
#
#   geocoder = new google.maps.Geocoder();
#   latlon = new google.maps.LatLng(lat/scale,lon/scale);
#
#
#   geocoder.geocode { 'latLng': latlon}, (results, status) ->
#     if status isnt google.maps.GeocoderStatus.OK
#       console.log 'Geocode error: ' + lat + ':' + lon + ': ' +  status
#       return
#     if not results[0]
#       console.log 'Geocode error: ' + lat + ':' + lon + ': ' + JSON.strinfify(results)
#       return
#     address = results[0].formatted_address
#     console.log 'Geocoded: ' + lat + ':' + lon + ': ' + address
#     Meteor.call 'cacheLocationName',  lat, lon, address
#
#   'loading...'
#
#
# aggOptions =
#   responsive:true
#   columns: [
#     {data: '_id', title: 'Date'}
#     {title: 'From/To', data: (obj)->
#       start = obj.startLat?.toFixed(2) + ':' + obj.startLon?.toFixed(2)
#       stop = obj.stopLat?.toFixed(2) + ':' + obj.stopLon?.toFixed(2)
#       startLocation = geocode2(30, obj.startLat, obj.startLon).split(',')[-3..]
#       stopLocation = geocode2(30, obj.stopLat, obj.stopLon).split(',')[-3..]
#       twin(startLocation,stopLocation)
#     }
#     {title: 'Distance/Odo', className: 'distance-col', data: (obj)->
#       # console.log 'Data: ' + JSON.stringify(obj)
#       km = Math.floor(obj.stopOdo/1000)
#       m = obj.stopOdo%1000
#       odo = km + ',' + m
#       twin(obj.sumDistance?.toFixed(2),odo)
#       # twin((obj.sumDistance/1000)?.toFixed(0),odo)
#     }
#     {title: 'Speed/Max', className: 'speed-col', data: (obj)-> twin(obj.avgSpeed?.toFixed(0),obj.maxSpeed?.toFixed(0)) }
#
#     {title: 'Trevel Time', className: 'time-col', data: (obj)->
#       time = moment.duration(obj.sumInterval, "seconds").format('HH:mm:ss', {trim: false})
#       twin(time, '')
#     }
#
#     # {title: 'Time/Idle', className: 'time-col', data: (obj)->
#     #   move = moment.duration(obj.sumMoveInterval, "seconds").format('HH:mm:ss', {trim: false})
#     #   idle = moment.duration(obj.sumIdleInterval, "seconds").format('HH:mm:ss', {trim: false})
#     #   twin(move,idle)
#     # }
#
#     {title: 'Fuel/Per 100', className: 'fuel-col', data: (obj)->
#       sumFuel = obj.sumFuel/1000
#       f = sumFuel?.toFixed(2)
#       fl = (sumFuel/obj.sumDistance*100)?.toFixed(2)
#       twin(f,fl)
#     }
#
#     {title: 'Map', tmpl: Template.aggMapCellTemplate}
#   ]
#
#
#
#
# Template.logbook.helpers
#   selector: ()-> Session.get(LOGBOOK_FILTER_NAME)
#   #filter: ()-> JSON.stringify(Session.get(LOGBOOK_FILTER_NAME))
#   # aggopts: createAggregationTableOptions
#   # startstopopts: createStartStopOptions
#   hideIdle: () -> Session.get(STARTSTOP_FILTER_NAME)?.hideIdle
#
#
#   aggDatafunc: ()->
#     () -> DateRangeAggregation.find().fetch()
#   aggOptions: aggOptions
#
#
# show = (obj) ->
#   str = ''
#   for p of obj
#     if obj.hasOwnProperty(p)
#       str += p + '::' + obj[p] + '\n'
#   return str
#
#
# Template.logbook.events
#   'cancel.daterangepicker #daterange': (event,p) ->
#     $('#daterange').val('')
#     filter = Session.get(LOGBOOK_FILTER_NAME) || {}
#     delete filter.recordTime
#     $("#speed").val('')
#     $(".agg-table tr").removeClass('selected')
#     Session.set LOGBOOK_FILTER_NAME, filter
#     Session.set STARTSTOP_FILTER_NAME, filter
#     # console.log 'Filter: ' + JSON.stringify(filter)
#   'apply.daterangepicker #daterange': (event,p) ->
#     startDate = $('#daterange').data('daterangepicker').startDate
#     endDate = $('#daterange').data('daterangepicker').endDate
#     console.log startDate.format('YYYY-MM-DD') + ' - ' + endDate.format('YYYY-MM-DD')
#     args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
#     args['$gte'] = startDate.toDate()
#     $("#speed").val('')
#     # args['$lte'] = endDate.add(1, 'days').toDate()
#     args['$lte'] = endDate.toDate()
#     Session.set LOGBOOK_FILTER_NAME, {recordTime: args}
#     Session.set STARTSTOP_FILTER_NAME, {recordTime: args}
#     # console.log 'logbook date filter: ' + JSON.stringify(Session.get(LOGBOOK_FILTER_NAME))
#   'change #speed': (event,p) ->
#     console.log 'Speed: ' + event.target.value
#     filter = Session.get(STARTSTOP_FILTER_NAME) || {}
#     speed = Number(event.target.value)
#     filter.speed = speed
#     Session.set STARTSTOP_FILTER_NAME, filter
#     # console.log 'Filter: ' + JSON.stringify(args)
#   'click #aggregated-table-section tr': (event,p)->
#     value = $('td', event.currentTarget).eq(0).text()
#     # console.log 'Click: ' + value
#     # name = $('td', this).eq(0).text()
#     startDate = moment(value)
#     endDate = moment(value).add(1, 'days')
#     # console.log 'Range: '
#     # console.log '  start: ' + startDate.format()
#     # console.log '  end  : ' + endDate.format()
#     args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
#     args['$gte'] = startDate.toDate()
#     args['$lte'] = endDate.toDate()
#     $("#speed").val('')
#     # console.log 'Filter: ' + JSON.stringify(args)
#     Session.set STARTSTOP_FILTER_NAME, {recordTime: args}
#     $("#aggregated-table-section tr").removeClass('selected')
#     event.currentTarget.setAttribute('class', 'selected')
#
#   'click #hideIdleCheckbox': (event,p)->
#     filter = Session.get(STARTSTOP_FILTER_NAME) || {}
#     console.log 'Clicked: ' + event.target.checked
#     filter.hideIdle = event.target.checked
#     Session.set STARTSTOP_FILTER_NAME, filter
#     # console.log 'Filter: ' + JSON.stringify(args)
