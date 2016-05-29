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

updateTyres = (v, distance, cb) ->
  if v
    console.log "Updating tyres for vehicle #{v._id}"
    Tyres.update {vehicle: v._id, active: true}, {$inc: {usedKm: distance}}, {multi: true}, (err) ->
      if err
        console.error "Failed updating tyres of vehicle #{v._id}! #{err}"
      else
        cb?(v)
  else
    console.log "No vehicle found for unit id #{v.unitId}"

@TraccarLogbookProcessor =
  insertRecord: (record) ->
    Partitioner.directOperation ->
      existing =
        deviceId: record.deviceId
        recordTime: record.recordTime
      if Logbook.findOne(existing)
        console.warn 'Duplicate record received:', existing
      else
        v = Vehicles.findOne {unitId: record.deviceId}

        record.odometer = if record?.attributes?.odometer
          record.attributes.odometer
        else
          (v?.odometer or 0) + (record?.distance or 0)

        if typeof record.recordTime is 'string'
          record.recordTime = new Date(record.recordTime)
        Logbook.insert record, ->
          console.log """Inserted logbook record:
            #{EJSON.stringify record}
          """

        updateVehicle v, record, ->
          'trip.id': record.attributes?.trip
          lastUpdate: record.recordTime
          lat: record.lat
          lng: record.lng
          loc: record.loc
          address: record.address
          odometer: record.odometer
          state: record.state
          tripTime: record.attributes?.tripTime
          idleTime: record.attributes?.idleTime
          restTime: record.attributes?.restTime
          speed: record.speed
          course: Math.round(record.course)

        updateTyres v, (record?.distance or 0)
