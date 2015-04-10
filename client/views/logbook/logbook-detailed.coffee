total = new ReactiveVar({})

Template.logbookStartStop.helpers
  selector: -> {date: @selectedDate}
  totalDistance: -> total.get().distance?.toFixed(0)
  totalFuel: -> (total.get().fuel/1000)?.toFixed(0)
  totalTravelTime: -> moment.duration(total.get().travelTime, "seconds").format('HH:mm:ss', {trim: false})

Template.logbookStartStop.rendered = ()->
  Meteor.call 'detailedTotals', Template.currentData().selectedDate, (err, res)-> 
    if not err
      console.log 'Detailed Total: ' + JSON.stringify(res)
      total.set(res[0])


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

