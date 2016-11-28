Meteor.methods
  'vehicle/history': (filter, deviceId) ->
    @unblock

    console.log 'vehicle/history'
    data = {}
    odometer =
      [
        {$match:
          deviceId: deviceId}
        {$project:
          date:
            $dateToString:
              format: "%Y-%m-%d", date: "$recordTime"
          odometer: "$odometer"
          speed: "$speed"
        }
        {$group:
          _id: "$date"
          startOdometer: $min: "$odometer"
          endOdometer: $max: "$odometer"
          maxSpeed: $max: "$speed"
        }
        {$project:
          date: "$_id"
          maxSpeed: $max: "$maxSpeed"
          startOdometer: "$startOdometer"
          endOdometer: "$endOdometer"
          distance: $subtract: ["$endOdometer", "$startOdometer"]
        }
        {$sort: _id: -1}
      ]
    data = Logbook.aggregate(odometer)

    expensesPipeline = (query) ->
      types = _.pluck(ExpenseTypes.find(query, {fields: _id: 1}).fetch(), '_id')
      [
        {$match:
          vehicle: Vehicles.findOne(unitId: deviceId)._id
          expenseType: $in: types
        }
        {$group:
          _id: "$date"
          total: $sum: "$total"
          totalVATIncluded: $sum: "$totalVATIncluded"
        }
        {$project:
          expense:
            total: "$total"
            totalVATIncluded: "$totalVATIncluded"
        }
      ]

    expTupple = (item) -> [moment(item._id).format('YYYY-MM-DD'), item.expense]
    expenses =
      fuels: _.object Expenses.aggregate(expensesPipeline({fuels: true})).map expTupple
      fines: _.object Expenses.aggregate(expensesPipeline({fines: true})).map expTupple
    data.map (item) ->
      item.expenses =
        fuels: expenses.fuels[item.date] or {}
        fines: expenses.fines[item.date] or {}
      item


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

  fullLogbook: (filter) ->
    @unblock()
    vehicles = {}
    deviceIds = Vehicles.aggregate [
      {$match: _groupId: Meteor.user().group}
      {$lookup:
        from: "fleets"
        localField: "allocatedToFleet"
        foreignField: "_id"
        as: "fleets"
      }
    ]
    .map (v) ->
      vehicles[v.unitId] = v
      v.unitId
    pipeline =
      [
        {$match: deviceId: $in: deviceIds}
        {$sort: recordTime: 1}
        {$group:
          _id:
            deviceId: "$deviceId"
            date:
              $dateToString:
                format: "%Y-%m-%d"
                date: "$recordTime"
          startOdometer: $min: "$odometer"
          endOdometer: $max: "$odometer"
          maxSpeed: $max: "$speed"
        }
        {$project:
          date: "$_id.date"
          deviceId: "$_id.deviceId"
          startOdometer: 1
          endOdometer: 1
          distance:
            $divide: [
              $subtract: [
                "$endOdometer"
                "$startOdometer"
              ]
              1000
          ]
          maxSpeed: 1
        }
      ]
    result = Logbook.aggregate(pipeline).map (r) ->
      vehicle = vehicles[r.deviceId]
      fleet = vehicle?.fleets?[0]
      r._id = "#{r.deviceId}/#{r.date}"
      r.vehicleName = vehicle?.name
      r.fleetName = fleet?.name
      r
    result = _.sortBy(result, (r) -> r.date).reverse()
    result
