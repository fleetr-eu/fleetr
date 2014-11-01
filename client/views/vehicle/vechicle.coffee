Template.vehicle.helpers
  vehicleSchema: -> Schema.vehicle
  vehicle: -> Vehicles.findOne _id: @vehicleId
