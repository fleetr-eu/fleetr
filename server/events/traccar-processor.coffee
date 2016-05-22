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

@TraccarLogbookProcessor =
  insertRecord: (record) ->
    Partitioner.directOperation ->
      existing =
        deviceId: record.deviceId
        recordTime: record.recordTime
      if Logbook.find existing
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
          idleTime: record.idleTime
          restTime: record.restTime
          speed: record.speed
          course: Math.round(record.course)
