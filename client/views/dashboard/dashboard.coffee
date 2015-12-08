Template.dashboard.helpers
   movingVehicles: -> Vehicles.find({ state : "start" }).count()
   restingVehicles: -> Vehicles.find({ state : "stop" }).count()
   idlingVehicles: -> Vehicles.find({ state : "start", speed: {$lt: 0.1}}).count()
   overspeedingVehicles: -> Vehicles.find({ state : "start", speed: {$gt: 120}}).count()
