Meteor.methods
  'vehicle/history': (deviceId) ->
    @unblock
    VehicleHistory.update {deviceId: deviceId}, {$set: expenses: {}}, {multi: true}

    data = {}
    odometer =
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
    Logbook.aggregate(odometer).map (r) ->
      r.date = moment([r._id.year, r._id.month - 1, r._id.day]).format('YYYY-MM-DD')
      r.deviceId = deviceId
      r.expenses = {}
      delete r._id
      data[r.date] = r

    expensesPipeline = (query) ->
      types = _.pluck(ExpenseTypes.find(query, {fields: _id: 1}).fetch(), '_id')
      [
        {$match:
          vehicle: Vehicles.findOne(unitId: deviceId)._id
          expenseType: $in: types
        }
        {$group:
          _id:
            vehicleId: "$vehicle"
            date: "$date"
          total: $sum: "$total"
          totalVATIncluded: $sum: "$totalVATIncluded"
        }
      ]

    createExpenses = (type) -> (r) ->
      date = moment(r._id.date).format('YYYY-MM-DD')
      exp = _.pick(r, 'total', 'totalVATIncluded')
      if data[date]
        data[date].expenses[type] = exp
      else
        VehicleHistory.update {deviceId: deviceId, date: date}, $set:
          "expenses.#{type}": exp
    Expenses.aggregate(expensesPipeline({fuels: true})).map createExpenses('fuels')
    Expenses.aggregate(expensesPipeline({fines: true})).map createExpenses('fines')

    for date, record of data
      VehicleHistory.upsert {deviceId: deviceId, date: date}, {$set: record}


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
      r.distance = (r.stopOdometer - r.startOdometer) / 1000 # convert to kms
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
