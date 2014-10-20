Template.vehicles.events
  'click .deleteVehicle': -> Meteor.call 'removeVehicle', @_id

Template.vehicles.helpers
  vehicles: ->
    filter =
      $regex: "#{Session.get('vehicleFilter').trim()}".replace ' ', '|'
      $options: 'i'
    Vehicles.find $or: [{licensePlate: filter}, {identificationNumber: filter}]

Template.vehicleTableRow.helpers
  fleetName: ->
     console.log(@allocatedToFleet)
     Fleets.findOne(_id : @allocatedToFleet).name