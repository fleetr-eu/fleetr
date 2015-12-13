@LogbookProcessor =
  insertRecord: (record) ->
    if typeof record.recordTime is 'string'
      record.recordTime = new Date(record.recordTime)
    record.loc = [record.lon, record.lat]
    Logbook.insert record, ->
      console.log "Inserted logbook record type #{record.type}: #{EJSON.stringify record}"

nullRecord =
  speed: 0
  trip:
    maxSpeed: 0
    avgSpeed: 0
    distance: 0
    consumedFuel: 0
  state: 'stop'

updateVehicle = (rec, updater, cb) ->
  Partitioner.directOperation ->
    if v = Vehicles.findOne {unitId: rec.deviceId}
      update = updater?(v)
      console.log "Updating vehicle #{v._id} with #{EJSON.stringify update}"
      Vehicles.update {_id: v._id}, $set: update, {}, (err) ->
        if err
          console.error "Failed updating vehicle #{v._id}! #{err}"
        else
          console.log "Updated vehicle #{v._id} with data from #{EJSON.stringify rec}"
          cb?(v)
    else
      console.log "No vehicle found for unit id #{rec.deviceId}"

@TripProcessor =
  deviceStart: (rec) ->
    console.log "device started #{rec.deviceId}"
    updateVehicle rec, ->
      data =
        time: rec.recordTime
        fuel: rec.fuelc
        lat: rec.lat
        lng: rec.lon
        address: Geocoder.reverse(rec.lat, rec.lon)?[0]
        odometer: rec.tacho

      if v.rest
        Rests.insert _.extend (v.rest or {}),
          stop: data
          duration: moment.duration(moment(rec.recordTime).diff(v.rest.start?.time))
      else
        console.warn "Rest stop without a corresponding start!"

      _.extend nullRecord,
        state: 'start'
        lastUpdate: rec.recordTime
        odometer: rec.tacho
        trip:
          date: moment(rec.recordTime).format('DD-MM-YYYY')
          start: data


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

      if v.trip
        trip = _.extend v.trip,
          stop: data
        Trips.insert trip, (err) ->
          if err
            console.error "Failed inserting trip #{EJSON.stringify trip}"
            console.error "Error was #{err}"
          else
            console.log "Inserted trip #{EJSON.stringify trip}"
      else
        console.warn "Trip stop without a corresponding start!"

      _.extend nullRecord,
        rest:
          date: moment(rec.recordTime).format('DD-MM-YYYY')
          start: data


  deviceMove: (rec) ->
    console.log "device moved #{rec.deviceId}"
    updateVehicle rec, (v) ->
      trip = v.trip or nullRecord.trip
      distance = rec.tacho - (trip.start?.odometer or 0)
      duration = moment.duration(moment(rec.recordTime)
        .diff(trip.start?.time or 0)).asHours()
      maxSpeed = if rec.speed > trip.maxSpeed
        rec.speed
      else
        trip.maxSpeed
      trip = _.extend trip,
        deviceId: v.unitId
        distance: distance / 1000
        consumedFuel: rec.fuelc - (trip.start?.fuel or 0)
        avgSpeed: (distance / 1000)/duration
        maxSpeed: v.maxMeasuredSpeed

      lastUpdate: rec.recordTime
      speed: rec.speed
      lat: rec.lat
      lon: rec.lon
      loc: [rec.lon, rec.lat]
      odometer: rec.tacho
      trip: trip
