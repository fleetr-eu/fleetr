@EventProcessor =
  devicePing: (record) ->
    console.log 'Received event type 0, just logging.', record

@LogbookProcessor =
  insertRecord: (record) ->
    if typeof record.recordTime is 'string'
      record.recordTime = new Date(record.recordTime)
    record.loc = [record.lon, record.lat]
    unless Logbook.findOne(deviceId: record.deviceId, offset: record.offset)
      Logbook.insert record, ->
        console.log "Inserted logbook record type #{record.type}: #{EJSON.stringify record}"

nullRecord = ->
  state: 'stop'
  speed: 0
  trip:
    maxSpeed: 0
    avgSpeed: 0
    distance: 0
    consumedFuel: 0
    path: null
  rest:
    duration: 0

calcDuration = (startTime, stopTime) ->
  moment.duration(moment(stopTime).diff(startTime or 0))

updateVehicle = (rec, updater, cb) ->
  Partitioner.directOperation ->
    if v = Vehicles.findOne {unitId: rec.deviceId}
      update = updater?(v)
      console.log "Updating vehicle #{v._id}"
      Vehicles.update {_id: v._id}, $set: update, {}, (err) ->
        if err
          console.error "Failed updating vehicle #{v._id}! #{err}"
        else
          cb?(v)
    else
      console.log "No vehicle found for unit id #{rec.deviceId}"

@TripProcessor =
  deviceStart: (rec) ->
    console.log "device started #{rec.deviceId}"
    updateVehicle rec, (v) ->
      data =
        time: rec.recordTime
        fuel: rec.fuelc
        lat: rec.lat
        lng: rec.lon
        address: Geocoder.reverse(rec.lat, rec.lon)?[0]
        odometer: rec.tacho

      if v.rest
        Rests.insert lodash.merge (v.rest or {}),
          stop: data
          duration: calcDuration(v.rest?.start?.time, rec.recordTime).asSeconds()
      else
        console.warn "Rest stop without a corresponding start!"

      lodash.merge nullRecord(),
        state: 'start'
        lastUpdate: rec.recordTime
        odometer: rec.tacho
        trip:
          deviceId: rec.deviceId
          date: moment(rec.recordTime).format('DD-MM-YYYY')
          start: data
          path: [
            lat: rec.lat
            lng: rec.lon
            time: rec.recordTime
            speed: rec.speed
            odometer: rec.tacho
          ]



  deviceStop: (rec) ->
    console.log "device stopped #{rec.deviceId}"
    updateVehicle rec, (v) ->
      data =
        time: rec.recordTime
        lat: rec.lat
        lng: rec.lon
        address: Geocoder.reverse(rec.lat, rec.lon)?[0]
        odometer: rec.tacho
        fuel: rec.fuelc

      trip = v.trip
      if trip
        distance = rec.tacho - (trip?.start?.odometer or 0)
        duration = calcDuration(trip?.start?.time, rec.recordTime).asHours()
        trip = lodash.merge trip,
          distance: distance / 1000
          consumedFuel: rec.fuelc - (trip?.start?.fuel or 0)
          avgSpeed: (distance / 1000)/duration
          stop: data
        Trips.insert trip, (err) ->
          if err
            console.error "Failed inserting trip #{EJSON.stringify trip}"
            console.error "Error was #{err}"
          else
            console.log "Inserted trip #{EJSON.stringify trip}"
      else
        console.warn "Trip stop without a corresponding start!"

      lodash.merge nullRecord(),
        lastUpdate: rec.recordTime
        odometer: rec.tacho
        rest:
          date: moment(rec.recordTime).format('DD-MM-YYYY')
          start: data


  deviceMove: (rec) ->
    console.log "device moved #{rec.deviceId}"
    updateVehicle rec, (v) ->
      maxSpeed = v.trip?.maxSpeed or 0
      maxSpeed = rec.speed if rec.speed > maxSpeed

      bearing = if (v.lat.toFixed(5) != rec.lat.toFixed(5)) or (v.lon.toFixed(5) != rec.lon.toFixed(5)) 
        dLon = (rec.lon - v.lon)

        y = Math.sin(dLon) * Math.cos(rec.lat)
        x = Math.cos(v.lat) * Math.sin(rec.lat) - Math.sin(v.lat) * Math.cos(rec.lat) * Math.cos(dLon)

        brng = Math.atan2(y, x)

        brng = brng* (180 / Math.PI)
        brng = (brng + 360) % 360
        brng = Math.round(360 - brng)
        console.log "course changed: #{brng} degrees"
        brng

      else v.course

      restDuration = if v.rest?.start?.time and v.state is 'stop'
        calcDuration(v.rest?.start?.time, rec.recordTime).asSeconds()
      else 0

      path = v.trip?.path
      if v.state is 'start'
        path?.push
          lat: rec.lat
          lng: rec.lon
          time: rec.recordTime
          speed: rec.speed
          odometer: rec.tacho
        path = _.sortBy path, (p) -> p.time
      else
        path = null

      'trip.maxSpeed': maxSpeed
      'trip.path': path
      'rest.duration': restDuration
      lastUpdate: rec.recordTime
      speed: if v.state is 'stop' then 0 else rec.speed
      lat: rec.lat
      lon: rec.lon
      loc: [rec.lon, rec.lat]
      odometer: rec.tacho
      course: bearing
