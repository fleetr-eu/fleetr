Template.vehicles.events
  'click .deleteVehicle': -> Meteor.call 'removeVehicle', Session.get('selectedVehicleId')
  'keyup input.search-query': -> Session.set 'filterVehicles', $('#filterVehicles').val()

Template.vehicles.helpers
  vehicles: ->
    filter =
      $regex: "#{Session.get('filterVehicles').trim()}".replace ' ', '|'
      $options: 'i'
    Vehicles.find $or: [{licensePlate: filter}, {identificationNumber: filter}]
  selectedVehicleId: -> Session.get('selectedVehicleId')

Template.vehicleTableRow.helpers
  fleetName: -> Fleets.findOne(_id : @allocatedToFleet).name
  active: -> if @_id == Session.get('selectedVehicleId') then 'active' else ''

Template.vehicleTableRow.events
  'click tr': -> Session.set 'selectedVehicleId', @_id
