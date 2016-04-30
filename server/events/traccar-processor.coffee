@TraccarLogbookProcessor =
  insertRecord: (record) ->
    if typeof record.recordTime is 'string'
      record.recordTime = new Date(record.recordTime)
    unless Logbook.findOne(deviceId: record.deviceId, offset: record.offset)
      Logbook.insert record, ->
        console.log "Inserted logbook record type #{record.type}: #{EJSON.stringify record}"
      updateVehicle1 record, (v) ->
        odometer = v.odometer + rec.distance
        data = currentRecord: rec, loc: rec.loc, odometer: odometer
        # ToDo: all the code needs to be updated to read from vehicle.currentRecord instead of vehicle, e.g., vehicle.currentRecord.state instead of vehicle.state

updateVehicle1 = (rec, updater, cb) ->
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