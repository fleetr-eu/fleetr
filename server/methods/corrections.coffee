Meteor.methods
  'corrections/odometer': (vehicleId, newOdometer, date) ->
    deviceId = Vehicles.findOne({_id: vehicleId}, {fields: unitId: 1})?.unitId

    recordsToUpdate =
      deviceId: deviceId
      recordTime: $gt: new Date date

    # find the next record
    rec = Logbook.findOne recordsToUpdate,
      sort: recordTime: 1
      fields:
        deviceId: 1
        recordTime: 1
        odometer: 1

    # update odometers
    odoInMeters = newOdometer * 1000
    correction = odoInMeters - rec.odometer
    # Logbook.update recordsToUpdate, {$inc: odometer: correction}, {multi: true}
    # Vehicles.update {_id: vehicleId}, {$inc: odometer: correction}

    correction: correction
    previousOdometer: rec.odometer
