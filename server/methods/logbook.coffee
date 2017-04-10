Meteor.methods
  'vehicle/history': (filter, deviceId) ->
    @unblock
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
          maxSpeed: 1
          startOdometer: 1
          endOdometer: 1
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
        {$project:
          deviceId: "$_id.deviceId"
          _id: "$_id.trip"
          date:
            $dateToString:
              format: "%Y-%m-%d"
              date: "$startTime"
          distance:
            $divide: [
              $subtract: [
                "$stopOdometer"
                "$startOdometer"
              ]
              1000
            ]
          startTime: 1
          stopTime: 1
          address:
            $concat: ['$startAddress', '\n', '$stopAddress']
          startOdometer: 1
          stopOdometer: 1
          startLat: 1
          startLng: 1
          stopLat: 1
          stopLng: 1
          maxSpeed: 1
          avgSpeed: 1
        }
        {$sort: startTime: -1}
      ]
    result = Logbook.aggregate(pipeline).map (r) ->
      trip = Trips.findOne tripId: r._id.trip
      r.isBusinessTrip =
        if trip?.isBusinessTrip is undefined
          true
        else trip?.isBusinessTrip
      r

  fullLogbook: (filter) ->
    @unblock()
    vehicles = {}
    deviceIds = Vehicles.aggregate [
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
        {$sort: date: -1}
      ]
    result = Logbook.aggregate(pipeline).map (r) ->
      vehicle = vehicles[r.deviceId]
      fleet = vehicle?.fleets?[0]
      r._id = "#{r.deviceId}/#{r.date}"
      r.vehicleName = "#{vehicle?.name} (#{vehicle?.licensePlate})"
      r.fleetName = fleet?.name
      r
