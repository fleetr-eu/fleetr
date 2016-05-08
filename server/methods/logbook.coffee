Meteor.methods
  'vehicle/history': (deviceId) ->
    @unblock
    pipeline =
      [
        {$match: deviceId: deviceId}
        {$group:
          _id:
            deviceId: "$deviceId"
            month: $month: "$recordTime"
            day: $dayOfMonth: "$recordTime"
            year: $year: "$recordTime"
          startOdometer: $min: "$odometer"
          endOdometer: $max: "$odometer"
          maxSpeed: $max: "$speed"
        }
      ]
    Logbook.aggregate(pipeline).map (r) ->
      r.date = moment([r._id.year, r._id.month - 1, r._id.day]).format('YYYY-MM-DD')
      r.deviceId = r._id.deviceId
      delete r._id
      VehicleHistory.upsert {deviceId: r.deviceId, date: r.date}, {$set: r}
