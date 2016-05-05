updateVehicle = (v, rec, updater, cb) ->
  if v
    update = updater?()
    console.log "Updating vehicle #{v._id}"
    Vehicles.update {_id: v._id}, {$set: update}, (err) ->
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
      odometer: (v.odometer or 0) + rec.distance
      address: rec.address
  else
    trip.path = []
  trip

@TraccarLogbookProcessor =
  insertRecord: (record) ->
    Partitioner.directOperation ->
      v = Vehicles.findOne {unitId: record.deviceId}
      if v and not record.odometer
        record.odometer = (v.odometer or 0) + (record.distance or 0)

      if typeof record.recordTime is 'string'
        record.recordTime = new Date(record.recordTime)
      Logbook.insert record, ->
        console.log """Inserted logbook record:
          #{EJSON.stringify record}
        """

      updateVehicle v, record, ->
        trip: updateTrip(v, record)
        lastUpdate: record.recordTime
        lat: record.lat
        lng: record.lng
        loc: record.loc
        address: record.address
        odometer: if v.odometer
          v.odometer + (record.distance + 0)
        else
          record.odometer or record.distance
        state: record.state
        idleTime: record.idleTime
        restTime: record.restTime
        speed: record.speed
        course: Math.round(record.course)
