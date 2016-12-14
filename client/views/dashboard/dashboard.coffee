Template.menuBoard.helpers
   movingVehicles: -> Vehicles.find({ state : "start", speed: {$gte: Settings.minSpeed}}).count()
   restingVehicles: -> Vehicles.find({ state : "stop" }).count()
   idlingVehicles: -> Vehicles.find({ state : "start", speed: {$lt: Settings.minSpeed}}).count()
   overspeedingVehicles: -> Vehicles.find({ state : "start", speed: {$gt: Settings.maxSpeed}}).count()
