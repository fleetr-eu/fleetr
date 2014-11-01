Template.vehicles.events
  'click .deleteVehicle': ->
    Meteor.call 'removeVehicle', Session.get('selectedVehicleId')
    Session.set 'selectedVehicleId', null

Template.vehicles.helpers
  vehicles: ->
    filter =
      $regex: "#{Session.get('vehicleFilter').trim()}".replace ' ', '|'
      $options: 'i'
    Vehicles.find $or: [{licensePlate: filter}, {identificationNumber: filter}]
  selectedVehicleId: -> Session.get('selectedVehicleId')

Template.vehicleTableRow.helpers
  fleetName: -> Fleets.findOne(_id : @allocatedToFleet).name
  active: -> if @_id == Session.get('selectedVehicleId') then 'active' else ''

Template.vehicleTableRow.events
  'click tr': -> Session.set 'selectedVehicleId', @_id
