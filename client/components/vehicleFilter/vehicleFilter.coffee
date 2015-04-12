Template.vehicleFilter.rendered = ->
  Session.set(@data.sessionVar, {}) if @data.sessionVar
  @subscribe 'fleetGroups'
  @autorun =>
    groupId = Session.get(@data.sessionVar)?.selectedFleetGroupId
    fleetId = Session.get(@data.sessionVar)?.selectedFleetId

    if groupId
      @subscribe 'fleets', parent: groupId
    else
      @subscribe 'fleets'

    if fleetId
      @subscribe 'vehicles', allocatedToFleet: fleetId
    else
      if groupId
        fleetIds = _.pluck(Fleets.find(parent: groupId).fetch(), '_id')
        @subscribe 'vehicles', allocatedToFleet: $in: fleetIds
      else
        @subscribe 'vehicles'

Template.vehicleFilter.helpers
  fleetGroups: -> FleetGroups.find {}, {sort: name: 1}
  fleets: ->
    groupId = Session.get(@sessionVar)?.selectedFleetGroupId
    Fleets.find (if groupId then parent: groupId else {}), {sort: name: 1}
  vehicles: ->
    fleetId = Session.get(@sessionVar)?.selectedFleetId
    if fleetId
      Vehicles.find {allocatedToFleet: fleetId}, {sort: name: 1}
    else
      groupId = Session.get(@sessionVar)?.selectedFleetGroupId
      if groupId
        fleetIds = _.pluck(Fleets.find(parent: groupId).fetch(), '_id')
        Vehicles.find {allocatedToFleet: $in: fleetIds}, {sort: name: 1}
      else
        Vehicles.find {}, {sort: name: 1}

Template.vehicleFilter.events
  'change .vehicle-filter.fleet-group': (e, t) ->
    if @sessionVar
      Session.set @sessionVar,
        selectedFleetGroupId: t.$('.fleet-group').val()
        selectedFleetId: undefined
        selectedVehicleId: undefined
  'change .vehicle-filter.fleet': (e, t) ->
    if @sessionVar
      Session.set @sessionVar,
        selectedFleetGroupId: t.$('.fleet-group').val()
        selectedFleetId: t.$('.fleet').val()
        selectedVehicleId: undefined
  'change .vehicle-filter.vehicle': (e, t) ->
    if @sessionVar
      Session.set @sessionVar,
        selectedFleetGroupId: t.$('.fleet-group').val()
        selectedFleetId: t.$('.fleet').val()
        selectedVehicleId: t.$('.vehicle').val()
