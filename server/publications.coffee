# Autopublish
Meteor.publish null, -> Alarms.find {seen: false}
# /Autopublish

Meteor.publish 'drivers', -> Drivers.find {}
Meteor.publish 'driver', (filter) -> if filter then Drivers.find(filter) else []
Meteor.publish 'countries', -> Countries.find {}
Meteor.publish 'vehicles', (filter = {}, opts = {}) ->
  Vehicles.find filter, opts
Meteor.publish 'tyres', (filter = {}) -> Tyres.find filter
Meteor.publish 'vehicle', (filter) ->
  if filter then Vehicles.find(filter) else []
Meteor.publish 'vehiclesMakes', -> Vehicles.find {}, {fields: makeAndModel: 1}
Meteor.publish 'fleetGroups', (filter = {}) ->
  FleetGroups.find filter, {$sort: {name: 1}}
Meteor.publish 'fleetGroup', (gid) -> FleetGroups.find {_id: gid}
Meteor.publish 'fleets', (filter) -> Fleets.find filter or {}
Meteor.publish 'fleet', (fid) -> Fleets.find {_id: fid}
Meteor.publish 'documentTypes', -> DocumentTypes.find {}
Meteor.publish 'geofenceEvents', -> GeofenceEvents.find {}
Meteor.publish 'customEvents', -> CustomEvents.find {}
Meteor.publish 'documents', (driverId) -> Documents.find driverId:driverId
Meteor.publish 'expenseGroups', -> ExpenseGroups.find {}
Meteor.publish 'expenseTypes', -> ExpenseTypes.find {}
Meteor.publish 'expenses', -> Expenses.find {}
Meteor.publish 'maintenanceTypes', -> MaintenanceTypes.find {}
Meteor.publish 'insuranceTypes', -> InsuranceTypes.find {}
Meteor.publish 'insurancePayments', -> InsurancePayments.find {}
Meteor.publish 'insurances', -> Insurances.find {}
Meteor.publish 'maintenanceType', (id) -> MaintenanceTypes.find _id: id
Meteor.publish 'vehicleMaintenances', (vehicleId)-> Maintenances.find {vehicle: vehicleId}
Meteor.publish 'alarms', -> Alarms.find {}
Meteor.publish 'notifications', -> Notifications.find {}
Meteor.publish 'geofences', (filter) -> Geofences.findFiltered filter, ['name', 'tags']
Meteor.publish 'driverVehicleAssignments', -> DriverVehicleAssignments.find {}
Meteor.publish 'driverVehicleAssignment', (filter) -> if filter then DriverVehicleAssignments.find filter else []
Meteor.publish 'aggbydate', (args) -> AggByDate.find(args || {})
Meteor.publish 'latest device position', (deviceId) -> Logbook.find {deviceId: deviceId}, {sort: {recordTime: -1}, limit: 1}
Meteor.publish 'idlebook'  , (args) -> IdleBook.find(args || {}, {sort: {startTime: 1}} )
Meteor.publish 'trips', (args) -> Trips.find(args || {}, {sort: {startTime: 1}} )
Meteor.publish 'tripsOfVehicle', (vehicleId, since) ->
  deviceId = Vehicles.findOne(_id: vehicleId).unitId
  query = deviceId: deviceId
  if since
    query['start.time'] = $gte: since
  Trips.find query,
    sort:
      startTime: 1
    fields:
      path: 0
Meteor.publish 'restsOfVehicle', (vehicleId) ->
  deviceId = Vehicles.findOne(_id: vehicleId).unitId
  Rests.find {deviceId: deviceId}, {sort: {startTime: 1}}

Meteor.publish 'alarm-definitions', -> AlarmDefinitions.find {}

Meteor.publish 'logbook', (searchArgs = {}) -> Logbook.find searchArgs, {sort: recordTime: -1}

Meteor.publish 'dateRangeAggregation', (args)->
  sub = this
  db = MongoInternals.defaultRemoteCollectionDriver().mongo.db
  rangeMatch = {$match: {}}
  if args
    rangeMatch = {$match: args}
  pipeline = [
    {$project : {
        startLat  : "$start.lat"
        stopLat   : "$stop.lat"
        startLon  : "$start.lon"
        stopLon   : "$stop.lon"

        startOdo  : "$start.tacho"
        stopOdo   : "$stop.tacho"


        date      : "$date"
        distance  : "$startStopDistance"
        speed     : "$startStopSpeed"
        interval  : "$interval"
        maxspeed  : "$maxSpeed"
        fuel      : "$fuelUsed"
      }
    },

    { $group : {
          _id: "$date"
          total: { $sum: 1 }
          sumDistance : { $sum: "$distance" }
          sumFuel     : { $sum: "$fuel" }
          sumInterval : { $sum: "$interval" }
          maxSpeed    : { $max: "$maxspeed" }
          avgSpeed    : { $avg: "$speed" }

          startLat: { $first: "$startLat" }
          stopLat: { $last: "$stopLat" }
          startLon: { $first: "$startLon" }
          stopLon: { $last: "$stopLon" }

          startTime: { $first: "$start.recordTime" }
          stopTime: { $last: "$stop.recordTime" }


          stopOdo  : { $last: "$stopOdo" }
      }}

  ]
  time = new Date().getTime()

  res = db.collection('startstop').aggregate pipeline, Meteor.bindEnvironment(
    (err, result) ->
      console.log 'Count: ' + result.length
      _.each result, (e) ->
        console.log 'Record: ' + JSON.stringify(e)
        sub.added "dateRangeAggregation", e._id, e if e.sumDistance > 0
      sub.ready()

    (error) ->
      Meteor._debug( "Error doing aggregation: " + error)
  )
  time = new Date().getTime() - time
  console.log 'Aggregated in: ' + time + 'ms'
  return res


Meteor.publish 'vehicleInfo', (unitId) ->
  vehiclesCursor = Vehicles.find unitId: "#{unitId}"
  v = vehiclesCursor.fetch()[0]
  fleetsCursor = Fleets.find _id: v?.allocatedToFleet
  [
    vehiclesCursor
    Drivers.find vehicle_id: v?._id
    fleetsCursor
    FleetGroups.find _id: fleetsCursor.fetch()[0]?.parent
  ]

Meteor.publish 'aggbydate-tabular', (tableName, ids, fields)->
  self = this
  subHandle = AggByDate.find({_id: {$in: ids}}, {fields: fields}).observeChanges(
    added: (id, fields) ->
      console.log 'Added: ' + JSON.stringify(fields,null,2)
      self.added 'aggbydate', id, fields
    changed: (id, fields) ->
      self.changed 'aggbydate', id, fields
    removed: (id) ->
      self.removed 'aggbydate', id
  )
  self.ready()
  self.onStop ->
    subHandle.stop()
