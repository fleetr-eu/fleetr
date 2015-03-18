Meteor.startup ->
  Meteor.publish 'drivers', -> Drivers.find {}
  Meteor.publish 'countries', -> Countries.find {}
  Meteor.publish 'vehicles', -> Vehicles.find {}
  Meteor.publish 'vehiclesMakes', -> VehiclesMakes.find {}
  Meteor.publish 'vehiclesModels', -> VehiclesModels.find {}
  Meteor.publish 'fleetGroups', -> FleetGroups.find {}, {$sort: {name: 1}}
  Meteor.publish 'fleetGroup', (gid) -> FleetGroups.find {_id: gid}
  Meteor.publish 'fleets', -> Fleets.find {}
  Meteor.publish 'fleet', (fid) -> Fleets.find {_id: fid}
  Meteor.publish 'expenseGroups', -> ExpenseGroups.find {}
  Meteor.publish 'expenseTypes', -> ExpenseTypes.find {}
  Meteor.publish 'expenses', -> Expenses.find {}
  Meteor.publish 'maintenanceTypes', -> MaintenanceTypes.find {}
  Meteor.publish 'vehicleMaintenances', (vehicleId)-> Maintenances.find {vehicle: vehicleId}
  Meteor.publish 'alarms', -> Alarms.find {}
  Meteor.publish 'notifications', -> Notifications.find {}
  Meteor.publish 'geofences', -> Geofences.find {}
  Meteor.publish 'driverVehicleAssignments', -> DriverVehicleAssignments.find {}

  Meteor.publish 'logbook', (args) -> Logbook.find(args || {}, {sort: {recordTime: -1}} ) 

  Meteor.publish 'locations', (vehicleId, dtFrom, dtTo) ->
    Locations.find {vehicleId: vehicleId, timestamp: {$gte: dtFrom*1000, $lte: dtTo*1000}}, {sort: {timestamp: -1}}

  Meteor.publish 'alarm-definitions', -> AlarmDefinitions.find {}
  Meteor.publish 'mycodes', -> MyCodes.find {}

  Meteor.publish 'dateRangeAggregation', (args)->
    sub = this
    db = MongoInternals.defaultRemoteCollectionDriver().mongo.db
    rangeMatch = {$match: {}}
    if args
      rangeMatch = {$match: args}
    pipeline = [
      {$match: {type: 30}}
      rangeMatch
      {$project : {
          type: "$type",
          speed: "$speed",
          tacho: "$tacho",
          distance: "$distance",
          fuelUsed: "$fuelUsed",
          recordTime: "$recordTime",
          lat: "$lat",
          lon: "$lon",
          year: { $substr: ["$recordTime",0,4] },
          month: { $substr: ["$recordTime",5,2] },
          day: { $substr: ["$recordTime",8,2] },
          timestamp: "$interval",
        }
      },
      {$project : {
          type: "$type",
          speed: "$speed",
          tacho: "$tacho",
          distance: "$distance",
          fuelUsed: "$fuelUsed",
          recordTime: "$recordTime",
          lat: "$lat",
          lon: "$lon",
          date: { $concat: ["$year","-","$month","-","$day"] },
          timestamp: "$interval",
        }
      },
      { $group : {
            _id: "$date"
            total: { $sum: 1 }
            minSpeed: { $min: "$speed" }
            maxSpeed: { $max: "$speed" }
            avgSpeed: { $avg: "$speed" }

            sumDistance: { $sum: "$distance" }
            lastOdometer: { $last: "$tacho" }
            startTime: { $first: "$recordTime" }
            stopTime: { $last: "$recordTime" }
            sumFuel: { $sum: "$fuelUsed" }
            sumInterval: { $sum: "$interval" }

            startLat: { $first: "$lat" }
            stopLat: { $last: "$lat" }

            startLon: { $first: "$lon" }
            stopLon: { $last: "$lon" }

            # avgFuelUsed: { $avg: "$speed" }
        }}
    ]
    time = new Date().getTime()

    res = db.collection('logbook').aggregate pipeline, Meteor.bindEnvironment(
      (err, result) ->
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
