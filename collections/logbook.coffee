@Logbook    = new Meteor.Collection "logbook"
@StartStop  = new Meteor.Collection "startstop"

isEven = (n) -> (n % 2) is 0
isOdd = (n) -> not isEven(n)
isStart = (r) -> isOdd(r.io)
isStop = (r) -> isEven(r.io)

calcDuration = (startTime, stopTime) ->
  moment.duration(moment(stopTime).diff(startTime or 0))

Meteor.methods
  createTrips: (deviceId, startDate) ->
    @unblock()
    if Meteor.isServer
      edgeRecs = Logbook.find
        deviceId: deviceId
        type: 29
        'start.time': $gte: startDate
      ,
        sort:
          recordTime: 1

      count = 1
      trip = {}
      edgeRecs.map (rec) ->
        if isStart rec
          trip =
            deviceId: rec.deviceId
            date: moment(rec.recordTime).format('DD-MM-YYYY')
            start:
              time: rec.recordTime
              fuel: rec.fuelc
              lat: rec.lat
              lng: rec.lng
              odometer: rec.tacho
              address: rec.address
        else if isStop(rec) and trip.start
          distance = rec.tacho - (trip?.start?.odometer or 0)
          duration = calcDuration(trip?.start?.time, rec.recordTime)
          trip = lodash.merge trip,
            distance: distance / 1000
            consumedFuel: rec.fuelc - (trip?.start?.fuel or 0)
            avgSpeed: (distance / 1000)/duration.asHours()
            duration: duration.asSeconds()
            stop:
              time: rec.recordTime
              lat: rec.lat
              lng: rec.lng
              address: rec.address
              odometer: rec.tacho
              fuel: rec.fuelc


          StartStop.upsert
            deviceId: rec.deviceId
            'start.time': trip.start.time
          , trip
          trip = {}
        else
          console.log "Stop without start at #{rec.recordTime}: #{count++}"
    ''
