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

  'vehicle/trips': (filter, aggParams) ->
    pipeline =
      [
        {$match:
          deviceId: aggParams.deviceId
          recordTime: $gt: moment().startOf(aggParams.timeRange).toDate()
          'attributes.trip': $exists: true
        }
        {$sort: recordTime: 1}
        {$group:
          _id:
            deviceId: "$deviceId"
            trip: "$attributes.trip"
          startTime: $min: "$recordTime"
          stopTime: $max: "$recordTime"
          startAddress: $first: "$address"
          stopAddress: $last: "$address"
          startOdometer: $min: "$odometer"
          stopOdometer: $max: "$odometer"
          startLat: $first: "$lat"
          startLng: $first: "$lng"
          stopLat: $last: "$lat"
          stopLng: $last: "$lng"
          maxSpeed: $max: "$speed"
          avgSpeed: $avg: "$speed"
        }
      ]
    result = Logbook.aggregate(pipeline).map (r) ->
      r.deviceId = r._id.deviceId
      r._id = r._id.trip
      r.date = moment(r.startTime).format('YYYY-MM-DD')
      r.distance = r.stopOdometer - r.startOdometer
      r
    _.sortBy(result, (r) -> moment(r.startTime).unix()).reverse()

  aggregateLogbook: (filter, deviceId) ->
    pipeline =
      [
        {$match: deviceId: deviceId}
        {$sort: recordTime: 1}
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
    result = Logbook.aggregate(pipeline).map (r) ->
      r._id = moment([r._id.year, r._id.month - 1, r._id.day]).format('YYYY-MM-DD')
      r
    _.sortBy(result, (r) -> r._id).reverse()
