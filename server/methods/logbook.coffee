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

  'trips/single/day': (deviceId, date) ->
    @unblock()
    getVehicleTrips({}, {deviceId: deviceId, date: date}).reverse().map (trip) ->
      trip.logbook = Logbook.find('attributes.trip': trip._id, {sort: recordTime: 1}).fetch()
      trip.speeding = (_.find trip.logbook, (point) -> point.speed > Settings.maxSpeed)?
      trip

  'vehicle/trips': getVehicleTrips = (filter, aggParams) ->
    @unblock?()
    recordTimeFilter = if tr = aggParams.timeRange
      $gte: moment().subtract(tr.offset, tr.unit).startOf(tr.unit).toDate()
    else if date = aggParams.date
      $gte: moment(date).startOf('day').toDate()
      $lte: moment(date).endOf('day').toDate()
    else throw Meteor.Error 'No params set, expected one of [timeRange, date]'
    pipeline =
      [
        {$match:
          deviceId: aggParams.deviceId
          recordTime: recordTimeFilter
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
        {$match:
          distance: $gte: Settings.minTripDistance
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
    # start from the beginning of previous month
    # to make the aggregation more performant
    fromStartOfPrevMonth = moment().subtract(1, 'month').startOf('month').toDate()
    pipeline =
      [
        {$match:
          deviceId: $in: deviceIds
          recordTime: $gt: fromStartOfPrevMonth
        }
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
