Template.vehicles.created = ->
  Session.setDefault 'vehicleFilter', ''

Template.vehicles.events
  'click .deleteVehicle': ->
    Meteor.call 'removeVehicle', Session.get('selectedVehicleId')
    Session.set 'selectedVehicleId', null

Template.vehicles.helpers
  vehicles: ->
    Vehicles.findFiltered 'vehicleFilter', ['licensePlate', 'identificationNumber', 'tags']
  selectedVehicleId: ->
    Session.get('selectedVehicleId')

Template.vehicleTableRow.helpers
  fleetName: -> Fleets.findOne(_id : @allocatedToFleet)?.name
  active: -> if @_id == Session.get('selectedVehicleId') then 'active' else ''
  allocatedToFleetFromDate: -> @allocatedToFleetFromDate.toLocaleDateString()
  tagsInfo: -> if @tags then "..." else ""
  stateImg: ->
    switch @state
      when "start"
        if @speed > @maxAllowedSpeed then "/images/truck-state-red.png" else "/images/truck-state-green.png"
      when "stop" then "/images/truck-state-blue.png"
      else "/images/truck-state-grey.png"

  formatedOdometer: ->
    (@odometer?/1000).toFixed(3)

  formatedSpeed: ->
    @speed?.toFixed(0)

Template.vehicleTableRow.events
  'click tr': -> Session.set 'selectedVehicleId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#vehicles #filter').val(tag)
    Session.set 'vehicleFilter', tag

Template.vehicleTableRow.rendered = ->
  $('[data-toggle="popover"]').popover()
