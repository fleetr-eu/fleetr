@DateRangeAggregation = new Mongo.Collection 'dateRangeAggregation'
# @StartStop = new Mongo.Collection 'startstop'

LOGBOOK_FILTER_NAME   = 'logbook-filter'
STARTSTOP_FILTER_NAME = 'logbook-startstop-filter'

Template.mapCellTemplate.helpers
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

Template.logbookStartStop.helpers
  selector: ->
    {date: @selectedDate}

Template.logbookStartStop.events

  'change #speed': (event,p) ->
    console.log 'Speed: ' + event.target.value
    filter = Session.get(STARTSTOP_FILTER_NAME) || {}
    speed = Number(event.target.value)
    filter.speed = speed
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(args)

  'click #hideIdleCheckbox': (event,p)->
    filter = Session.get(STARTSTOP_FILTER_NAME) || {}
    console.log 'Clicked: ' + event.target.checked
    filter.hideIdle = event.target.checked
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(args)
