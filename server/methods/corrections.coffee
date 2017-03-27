{ submitItem, removeItem } = require '/imports/lib/db.coffee'

correctOdometer = (vehicleId, newOdometer, date, cb) ->
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
  Logbook.update recordsToUpdate, {$inc: odometer: correction}, {multi: true}
  Vehicles.update {_id: vehicleId}, {$inc: odometer: correction}

  cb? null,
    odometer: odoInMeters
    correction: correction
    previousOdometer: rec.odometer


Meteor.startup ->
  Meteor.methods
    submitOdometer: (doc, id) ->
      if id
        throw new Meteor.Error "Editing odometer correction is not allowed!"

      if Meteor.isServer
        data = doc.$set
        correctOdometer data.vehicleId, data.value, data.dateTime, (err, result) =>
          if err
            throw new Meteor.Error err
          else
            doc.$set.value = result.odometer
            doc.$set.correction = result.correction
            doc.$set.oldValue = result.previousOdometer
            submitItem(Odometers).call @, doc, id
      else
        doc.$set.value = doc.$set.value * 1000 # convert to meters
        submitItem(Odometers).call @, doc, id
    removeOdometer: (id) ->
      # check if this is the last correction, if not - throw
      # removeItem(Odometers).call @, id
      throw new Meteor.Error "Removing odometer correction is not allowed!"
