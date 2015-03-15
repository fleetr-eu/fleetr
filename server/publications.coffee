Meteor.startup ->
  Meteor.publish 'drivers', -> Drivers.find {}
  Meteor.publish 'countries', -> Countries.find {}
  Meteor.publish 'vehicles', -> Vehicles.find {}
  Meteor.publish 'vehiclesMakes', -> VehiclesMakes.find {}
  Meteor.publish 'vehiclesModels', -> VehiclesModels.find {}
  Meteor.publish 'fleetGroups', -> FleetGroups.find {}, {$sort: {name: 1}}
  Meteor.publish 'fleets', -> Fleets.find {}
  Meteor.publish 'expenseGroups', -> ExpenseGroups.find {}
  Meteor.publish 'expenseTypes', -> ExpenseTypes.find {}
  Meteor.publish 'expenses', -> Expenses.find {}
  Meteor.publish 'alarms', -> Alarms.find {}
  Meteor.publish 'notifications', -> Notifications.find {}
  Meteor.publish 'geofences', -> Geofences.find {}
  Meteor.publish 'driverVehicleAssignments', -> DriverVehicleAssignments.find {}

  Meteor.publish 'logbook', (args) -> console.log args; Logbook.find args || {}

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
          distance: "$distance", 
          fuelUsed: "$fuelUsed", 
          year: { $substr: ["$recordTime",0,4] },
          month: { $substr: ["$recordTime",5,2] },
          day: { $substr: ["$recordTime",8,2] },
        }
      },
      {$project : {
          type: "$type",
          speed: "$speed",
          distance: "$distance", 
          fuelUsed: "$fuelUsed", 
          date: { $concat: ["$year","-","$month","-","$day"] },

        }
      },
      { $group : {
            _id: "$date"
            total: { $sum: 1 }
            minSpeed: { $min: "$speed" }
            maxSpeed: { $max: "$speed" }
            avgSpeed: { $avg: "$speed" }

            sumDistance: { $sum: "$distance" }
            sumFuel: { $sum: "$fuelUsed" }
            # avgFuelUsed: { $avg: "$speed" }
        }}
    ]
    db.collection('logbook').aggregate pipeline, Meteor.bindEnvironment(
      (err, result) ->
        _.each result, (e) ->
          sub.added "dateRangeAggregation", e._id, e
        sub.ready()

      (error) ->
        Meteor._debug( "Error doing aggregation: " + error)
    )
