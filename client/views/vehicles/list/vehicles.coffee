Template.vehicles.created = ->
  Session.setDefault 'vehicleFilter', ''
  Session.setDefault 'loggedVehicle', ''
  Meteor.subscribe 'locations', Session.get('selectedVehicleId'), Session.get("mapDateRangeFrom"), Session.get("mapDateRangeTo")

Template.vehicles.rendered = ->
  @autorun ->
    Meteor.subscribe 'locations', Session.get('selectedVehicleId')

Template.vehicles.destroyed = ->
  Meteor.clearInterval(Session.get('loggingLocationInterval'))

Template.vehicles.events
  'click .deleteVehicle': ->
    Meteor.call 'removeVehicle', Session.get('selectedVehicleId')
    Session.set 'selectedVehicleId', null
  "click .startLocationLogging" : (e) ->
      Session.set "loggedVehicle", Session.get('selectedVehicleId')
      Session.set 'loggingLocationInterval', Meteor.setInterval(Locations.log, 5000)
  "click .stopLocationLogging" : (e) ->
      Session.set "loggedVehicle", ''
      Meteor.clearInterval(Session.get('loggingLocationInterval'))
      Session.set 'loggingLocationInterval', ''

Template.vehicles.helpers
  vehicles: ->
    Vehicles.findFiltered 'vehicleFilter', ['licensePlate', 'identificationNumber', 'tags']
  selectedVehicleId: ->
    Session.get('selectedVehicleId')

Template.vehicleTableRow.helpers
  fleetName: -> Fleets.findOne(_id : @allocatedToFleet)?.name
  active: -> if @_id == Session.get('selectedVehicleId') then 'active' else ''
  allocatedToFleetFromDate: -> @allocatedToFleetFromDate.toLocaleDateString()
  tagsArray: -> tagsAsArray.call @
  logging: -> if @_id == Session.get('loggedVehicle') then "[L]" else ""

Template.vehicleTableRow.events
  'click tr': -> Session.set 'selectedVehicleId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#vehicles #filter').val(tag)
    Session.set 'vehicleFilter', tag
