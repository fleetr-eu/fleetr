Meteor.methods
  aggregateTrips: (filter, deviceId) ->
    pipeline =
      [
        {$match:
          deviceId: deviceId
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

  getUser: -> Meteor.user()

  toggleNotificationSeen: (id, oldSeenState) ->
    newSeenState = !oldSeenState
    Notifications.update {_id: id}, {$set: {seen: newSeenState}}

  toggleAlarmSeen: (id, oldSeenState) ->
    newSeenState = !oldSeenState
    Alarms.update {_id: id}, {$set: {seen: newSeenState}}

  reset: () ->
    @unblock()
    Alarms.remove {}
    Notifications.remove {}
    Drivers.find().forEach (doc) ->
      Drivers.utils.processNotifications(doc, doc._id)

  aggByDateTotals: ->
    AggByDate.aggregate [
      $group:
        _id: null
        distance  : {$sum: "$sumDistance"}
        travelTime: {$sum: "$sumInterval"}
        idleTime  : {$sum: "$idleTime"}
        fuel      : {$sum: "$sumFuel"}
    ]

  detailedTotals: (date)->
    StartStop.aggregate [
      {$match: {date: date}}
      $group:
        _id: null
        distance  : {$sum: "$startStopDistance"}
        travelTime: {$sum: "$interval"}
        fuel      : {$sum: "$fuelUsed"}
    ]

  idleTotals: (date)->
    IdleBook.aggregate [
      {$match: {date: date}}
      $group:
        _id: null
        idleTime: {$sum: "$duration"}
    ]

  getExpenses: (filter = {}) ->
    searchObject = {}
    if filter.startDate and filter.endDate
      searchObject.date = $gte: new Date(filter.startDate), $lte: new Date(filter.endDate)

    Expenses.find(searchObject).map (expense) ->
      expense.expenseTypeName = ExpenseTypes.findOne({_id: expense.expenseType})?.name
      expense.expenseGroupName = ExpenseGroups.findOne({_id: expense.expenseGroup})?.name
      expense.driverName = Drivers.findOne({_id: expense.driver})?.name
      vehicle = Vehicles.findOne({_id: expense.vehicle})
      expense.vehicleName = vehicle?.name
      expense.fleetName = Fleets.findOne(_id: vehicle?.allocatedToFleet)?.name
      expense # return the expense

  getMaintenanceVehicles: (filter = {}) ->
    pipeline = [
      $project:
        vehicle: 1
        nextMaintenanceDate : 1
        nextMaintenanceOdometer: 1
        nextMaintenanceEngineHours: 1
        daysToMaintenance: $divide: [$subtract: ["$nextMaintenanceDate", new Date()], 1000 * 60 * 60 * 24]
        odometerToMaintenance: $subtract: ["$nextMaintenanceOdometer", "$odometer"]
        engineHoursToMaintenance: $subtract: ["$nextMaintenanceEngineHours", "$engineHours"]
        performed: 1
    ]
    pipeline.push $match: performed: $ne: true
    if filter.daysToMaintenance
      pipeline.push $match: daysToMaintenance: $lte: parseInt filter.daysToMaintenance.regex
    if filter.odometerToMaintenance
      pipeline.push $match: odometerToMaintenance: $lte: parseInt filter.odometerToMaintenance.regex
    if filter.engineHoursToMaintenance
      pipeline.push $match: engineHoursToMaintenance: $lte: parseInt filter.engineHoursToMaintenance.regex
    if filter.nextMaintenanceOdometer
      pipeline.push $match: nextMaintenanceOdometer: $lte: parseInt filter.nextMaintenanceOdometer.regex
    if filter.nextMaintenanceEngineHours
      pipeline.push $match: nextMaintenanceEngineHours: $lte: parseInt filter.nextMaintenanceEngineHours.regex
    if filter.maintenanceDateMin and filter.maintenanceDateMax
      pipeline.push $match: nextMaintenanceDate: $gte: new Date(filter.maintenanceDateMin), $lte: new Date(filter.maintenanceDateMax)

    m = Maintenances.aggregate(pipeline).map (maintenance) ->
      vehicle = Vehicles.findOne _id: maintenance.vehicle
      maintenance.vehicleName = vehicle.name
      maintenance.fleetName = Fleets.findOne(_id: vehicle?.allocatedToFleet)?.name
      maintenance
