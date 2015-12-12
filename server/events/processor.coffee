@LogbookProcessor =
  insertRecord: (record) ->
    if typeof record.recordTime is 'string'
      record.recordTime = new Date(record.recordTime)
    record.loc = [record.lon, record.lat]
    Logbook.insert record, ->
      console.log "Inserted logbook record #{EJSON.stringify record}"

nullRecord =
  speed: 0
  trip:
    maxSpeed: 0
    avgSpeed: 0
    distance: 0
    consumedFuel: 0
  restTime: 0
  idleTime: 0
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
      _.extend nullRecord,
        state: 'start'
        lastUpdate: rec.recordTime
        odometer: rec.tacho
        trip:
          start:
            date: moment(rec.recordTime).format('DD-MM-YYYY')
            time: rec.recordTime
            fuel: rec.fuelc
            lat: rec.lat
            lon: rec.lon
            address: Geocoder.reverse(rec.lat, rec.lon)[0]
            odometer: rec.tacho

  deviceStop: (rec) ->
    console.log "device stopped #{rec.deviceId}"
    updateVehicle rec, (v) ->
      trip = _.extend (v.trip or nullRecord.trip),
        stop:
          time: rec.recordTime
          lat: rec.lat
          lng: rec.lon
          address: Geocoder.reverse(rec.lat, rec.lon)[0]
          odometer: rec.tacho
          fuel: rec.fuelc
      Trips.insert trip, (err) ->
        if err
          console.error "Failed inserting trip #{EJSON.stringify trip}"
          console.error "Error was #{err}"
        else
          console.log "Inserted trip #{EJSON.stringify trip}"
      nullRecord

  deviceMove: (rec) ->
    console.log "device moved #{rec.deviceId}"
    updateVehicle rec, (v) ->
      trip = v.trip or nullRecord.trip
      # if v.state == 'start'
      distance = rec.tacho - (trip.start?.odometer or 0)
      duration = moment.duration(moment(rec.recordTime)
        .diff(trip.start?.time or 0)).asHours()
      maxSpeed = if rec.speed > trip.maxSpeed
        rec.speed
      else
        trip.maxSpeed
      if distance < 5
        idleTime = v.idleTime + (rec.recordTime - v.lastUpdate)
      trip = _.extend trip,
        deviceId: v.unitId
        distance: distance / 1000
        consumedFuel: rec.fuelc - (trip.start?.fuel or 0)
        avgSpeed: (distance / 1000)/duration
        maxSpeed: v.maxMeasuredSpeed

      lastUpdate: rec.recordTime
      speed: rec.speed
      restTime: 0
      idleTime: idleTime or 0
      lat: rec.lat
      lon: rec.lon
      odometer: rec.tacho
      trip: trip

      # else
      #   lastUpdate: rec.recordTime
        # restTime: v.restTime + rec.recordTime - v.lastUpdate
