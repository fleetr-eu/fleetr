Meteor.publish 'drivers', -> Drivers.find {}
Meteor.publish 'driver', (filter) -> if filter then Drivers.find(filter) else []
Meteor.publish 'countries', -> Countries.find {}
Meteor.publish 'vehicles', (filter) -> if filter then Vehicles.find filter else Vehicles.find {}
Meteor.publish 'vehicle', (filter) -> if filter then Vehicles.find(filter) else []
Meteor.publish 'vehiclesMakes', -> VehiclesMakes.find {}
Meteor.publish 'vehiclesModels', -> VehiclesModels.find {}
Meteor.publish 'fleetGroups', -> FleetGroups.find {}, {$sort: {name: 1}}
Meteor.publish 'fleetGroup', (gid) -> FleetGroups.find {_id: gid}
Meteor.publish 'fleets', (filter) -> if filter then Fleets.find filter else Fleets.find {}
Meteor.publish 'fleet', (fid) -> Fleets.find {_id: fid}
Meteor.publish 'expenseGroups', -> ExpenseGroups.find {}
Meteor.publish 'expenseTypes', -> ExpenseTypes.find {}
Meteor.publish 'expenses', -> Expenses.find {}
Meteor.publish 'maintenanceTypes', -> MaintenanceTypes.find {}
Meteor.publish 'maintenanceType', (id) -> MaintenanceTypes.find _id: id
Meteor.publish 'vehicleMaintenances', (vehicleId)-> Maintenances.find {vehicle: vehicleId}
Meteor.publish 'alarms', -> Alarms.find {}
Meteor.publish 'notifications', -> Notifications.find {}
Meteor.publish 'geofences', -> Geofences.find {}
Meteor.publish 'driverVehicleAssignments', -> DriverVehicleAssignments.find {}
Meteor.publish 'driverVehicleAssignment', (filter) ->
  if filter then DriverVehicleAssignments.find filter else []

Meteor.publish 'startstop', (args) -> StartStop.find(args || {}, {sort: {startTime: 1}} )
Meteor.publish 'aggbydate', (args) -> AggByDate.find(args || {})
Meteor.publish 'latest device position', (deviceId) ->
  Logbook.find {deviceId: deviceId}, {sort: {recordTime: -1}, limit: 1}
Meteor.publish 'idlebook'  , (args) -> IdleBook.find(args || {}, {sort: {startTime: 1}} )

Meteor.publish 'locations', (vehicleId, dtFrom, dtTo) ->
  Locations.find {vehicleId: vehicleId, timestamp: {$gte: dtFrom*1000, $lte: dtTo*1000}}, {sort: {timestamp: -1}}

Meteor.publish 'alarm-definitions', -> AlarmDefinitions.find {}
# Meteor.publish 'mycodes', -> MyCodes.find {}

Meteor.publish 'logbook', (searchArgs) -> Logbook.find searchArgs, {sort: recordTime: -1}

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


Meteor.publishComposite 'vehicleInfo', (unitId) ->
  find: ->
    Vehicles.find unitId: unitId
  children: [
    {
      find: (vehicle) ->
        Fleets.find _id: vehicle.allocatedToFleet
      children: [
        {
          find: (fleet) ->
            FleetGroups.find _id: fleet.parent
        }
      ]
    },
    {
      find: (vehicle) ->
        DriverVehicleAssignments.find vehicle: vehicle._id
      children: [
        {
          find: (assignment) ->
            Drivers.find assignment.driver
        }
      ]
    }
  ]

# Meteor.publish "aggbydate-tabular", (tableName, ids, fields)->
# return AggByDate.find {_id: {$in: ids}}, {fields: fields, sort: {date: 1}}

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
