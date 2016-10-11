Meteor.methods
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
