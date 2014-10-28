Template.vehicles.events
  'click .deleteVehicle': -> Meteor.call 'removeVehicle', @_id
  'keyup input.search-query': -> Session.set 'filterVehicles', $('#filterVehicles').val()

Template.vehicles.helpers
  vehicles: ->
    filter =
      $regex: "#{Session.get('filterVehicles').trim()}".replace ' ', '|'
      $options: 'i'
    Vehicles.find $or: [{licensePlate: filter}, {identificationNumber: filter}]

Template.vehicleTableRow.helpers
  fleetName: ->
     console.log(@allocatedToFleet)
     Fleets.findOne(_id : @allocatedToFleet).name