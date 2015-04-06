Template.logbookStartStop.helpers
  selector: -> {date: @selectedDate}
  totalDistance: () ->
    total = 0
    StartStop.find().forEach (rec)-> 
      total += rec.startStopDistance
    total.toFixed(0) 
  totalTravelTime: () ->
    total = 0
    StartStop.find().forEach (rec)-> 
      total += rec.interval
    moment.duration(total, "seconds").format('HH:mm:ss', {trim: false})

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

