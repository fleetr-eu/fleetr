Template.logbookIdle.created = ->
  Meteor.subscribe 'idlebook'


Template.logbookIdle.rendered = ->
  select = '<select id="selectDuration" aria-controls="DataTables_Table_0" class="form-control input-sm">
                  <option value="">all</option>
                  <option value="60">1 min</option>
                  <option value="300">5 min</option>
                  <option value="600">10 min</option>
                  <option value="1800">30 min</option>
                  <option value="3600">1 hour</option>
               </select>'
  $("#DataTables_Table_0_length").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_filter").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_length").parent().addClass("col-sm-4")
  $("#DataTables_Table_0_filter").parent().addClass("col-sm-8")
  $("#DataTables_Table_0_filter").prepend(select)

Template.logbookIdle.events
  'change #selectDuration': ->
    val = $('#selectDuration').val()
    console.log 'Selected: ' + val
    Session.set "selected-min-duration" , val



Template.logbookIdle.helpers
  selector: -> 
    search = {date: @selectedDate}
    if Session.get("selected-min-duration")
      duration = parseInt(Session.get("selected-min-duration")) 
      search.duration = {$gte: duration}
    console.log 'Search: ' + JSON.stringify(search)
    search


Template.mapIdleCellTemplate.helpers
  opts: -> encodeURIComponent EJSON.stringify
    deviceId: @start.deviceId
    start:
      time: moment(@start.recordTime).valueOf()
      position:
        lat: @start.lat
        lng: @start.lon
    stop:
      time: moment(@stop.recordTime).valueOf()
      position:
        lat: @stop.lat
        lng: @stop.lon

Template.idleDetailsCellTemplate.helpers
  datetime: ->
    date     : @date 
    startTime: @from()
    stopTime : @to()




# Template.logbookStartStopIdle.events

#   'change #speed': (event,p) ->
#     console.log 'Speed: ' + event.target.value
#     filter = Session.get(STARTSTOP_FILTER_NAME) || {}
#     speed = Number(event.target.value)
#     filter.speed = speed
#     Session.set STARTSTOP_FILTER_NAME, filter
#     # console.log 'Filter: ' + JSON.stringify(args)

#   'click #hideIdleCheckbox': (event,p)->
#     filter = Session.get(STARTSTOP_FILTER_NAME) || {}
#     console.log 'Clicked: ' + event.target.checked
#     filter.hideIdle = event.target.checked
#     Session.set STARTSTOP_FILTER_NAME, filter
#     # console.log 'Filter: ' + JSON.stringify(args)
