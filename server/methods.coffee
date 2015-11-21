submitItem = (collection) -> (doc, diff) ->
  @unblock()
  collection.submit doc, diff

removeItem = (collection) -> (doc, diff) ->
  @unblock()
  collection.remove _id: doc


Meteor.methods
  getUser: -> Meteor.user()

  submitGeofence: (doc) ->
    if Geofences.findOne(_id: doc._id)
      Geofences.update {_id: doc._id}, {$set: _.omit(doc, '_id')}
    else
      Geofences.insert doc

  removeGeofence: (gfId) -> Geofences.remove _id: gfId

  addLocation: (doc) ->
    @unblock()
    Locations.insert doc

  submitDriver: submitItem Drivers
  removeDriver: removeItem Drivers

  submitVehicle: submitItem Vehicles
  removeVehicle: removeItem Vehicles

  submitFleetGroup: submitItem FleetGroups
  removeFleetGroup: removeItem FleetGroups

  submitFleet: submitItem Fleets
  removeFleet: removeItem Fleets

  submitTyre: submitItem Tyres
  removeTyre: removeItem Tyres

  submitMaintenanceType: submitItem MaintenanceTypes
  removeMaintenanceType: removeItem MaintenanceTypes

  submitInsuranceType: submitItem InsuranceTypes
  removeInsuranceType: removeItem InsuranceTypes

  submitMaintenance: submitItem Maintenances

  submitExpenseGroup: submitItem ExpenseGroups
  removeExpenseGroup: removeItem ExpenseGroups

  submitExpenseType: submitItem ExpenseTypes
  removeExpenseType: removeItem ExpenseTypes

  submitExpense: submitItem Expenses
  removeExpenses: removeItem Expenses

  toggleNotificationSeen: (id, oldSeenState) ->
    newSeenState = !oldSeenState
    Notifications.update {_id: id}, {$set: {seen: newSeenState}}

  toggleAlarmSeen: (id, oldSeenState) ->
    newSeenState = !oldSeenState
    Alarms.update {_id: id}, {$set: {seen: newSeenState}}

  removeLocation: (locationId) -> Locations.remove _id: locationId

  reset: () ->
    @unblock()
    Locations.remove {}
    Alarms.remove {}
    Notifications.remove {}
    Drivers.find().forEach (doc) ->
      Drivers.utils.processNotifications(doc, doc._id)

  submitDriverVehicleAssignment: (doc, diff) ->
    @unblock
    DriverVehicleAssignments.submit(doc, diff)
    Drivers.update {_id: doc.driver}, {$set: vehicle_id: doc.vehicle}
    Vehicles.update {_id: doc.vehicle}, {$set: driver_id: doc.driver}

  removeDriverVehicleAssignment: (doc) -> DriverVehicleAssignments.remove _id : doc

  cacheLocationName: (lat,lon,address) ->
    doc = MyCodes.findOne {lat: lat, lon: lon}
    if doc
      console.log 'Cached: ' + JSON.stringify(doc)
      #MyCodes.update {_id: doc._id}, {$set: {address: address}}
    else
      doc = {lat: lat, lon: lon, address: address}
      console.log 'Insert cache: ' + JSON.stringify(doc)
      MyCodes.insert doc
    doc

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
        maintenanceDate: 1
        vehicle: 1
        nextMaintenanceOdometer: 1
        nextMaintenanceEngineHours: 1
        odometerToMaintenance: $subtract: ["$nextMaintenanceOdometer", "$odometer"]
        engineHoursToMaintenance: $subtract: ["$nextMaintenanceEngineHours", "$engineHours"]
    ]
    if filter.odometerToMaintenance
      pipeline.push $match: odometerToMaintenance: $lte: parseInt filter.odometerToMaintenance.regex
    if filter.engineHoursToMaintenance
      pipeline.push $match: engineHoursToMaintenance: $lte: parseInt filter.engineHoursToMaintenance.regex
    if filter.nextMaintenanceOdometer
      pipeline.push $match: nextMaintenanceOdometer: $lte: parseInt filter.nextMaintenanceOdometer.regex
    if filter.nextMaintenanceEngineHours
      pipeline.push $match: nextMaintenanceEngineHours: $lte: parseInt filter.nextMaintenanceEngineHours.regex
    if filter.maintenanceDateMin and filter.maintenanceDateMax
      pipeline.push $match: maintenanceDate: $gte: new Date(filter.maintenanceDateMin), $lte: new Date(filter.maintenanceDateMax)

    Maintenances.aggregate(pipeline).map (maintenance) ->
      vehicle = Vehicles.findOne _id: maintenance.vehicle
      maintenance.vehicleName = vehicle.name
      maintenance.fleetName = Fleets.findOne(_id: vehicle?.allocatedToFleet)?.name
      maintenance
