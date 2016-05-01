@TraccarLogbookProcessor =
  insertRecord: (record) ->
    if typeof record.recordTime is 'string'
      record.recordTime = new Date(record.recordTime)
    # unless Logbook.findOne(deviceId: record.deviceId, offset: record.offset)
    Logbook.insert record, ->
      console.log "Inserted logbook record type #{record.type}: #{EJSON.stringify record}"

    updateVehicle record, (v) ->
      trip: updateTrip(v, record)
      lastUpdate: record.recordTime
      lat: record.lat
      lng: record.lng
      loc: record.loc
      address: record.address
      odometer: (v.odometer or 0) + record.distance
      state: record.state
      idleTime: record.idleTime
      restTime: record.restTime
      speed: record.speed
      course: Math.round(record.course)

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


updateTrip = (v, rec) ->
  trip = v.trip or {path: []}
  if rec.attributes?.trip
    unless trip.id is rec.attributes?.trip
      trip.path = []
      trip.id = rec.attributes?.trip
    trip.path.push
      lat: rec.lat
      lng: rec.lng
      time: rec.recordTime
      speed: rec.speed
      odometer: rec.tacho
  else
    trip.path = []
  trip
