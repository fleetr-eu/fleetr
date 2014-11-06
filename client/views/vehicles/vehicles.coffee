Template.vehicles.created = ->Session.setDefault 'vehicleFilter', ''

Template.vehicles.events
  'click .deleteVehicle': ->
    Meteor.call 'removeVehicle', Session.get('selectedVehicleId')
    Session.set 'selectedVehicleId', null

Template.vehicles.helpers
  vehicles: ->
    Vehicles.findFiltered 'vehicleFilter', ['licensePlate', 'identificationNumber', 'tags']
  selectedVehicleId: -> Session.get('selectedVehicleId')

Template.vehicleTableRow.helpers
  fleetName: -> Fleets.findOne(_id : @allocatedToFleet)?.name
  active: -> if @_id == Session.get('selectedVehicleId') then 'active' else ''
  allocatedToFleetFromDate: -> @allocatedToFleetFromDate.toLocaleDateString()
  tagsArray: -> tagsArray.call @

Template.vehicleTableRow.events
  'click tr': -> Session.set 'selectedVehicleId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#vehicles #filter').val(tag)
    Session.set 'vehicleFilter', tag
