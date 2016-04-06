sortByName = sort: name: 1

set = (sessVar, val) -> Session.set sessVar, val if sessVar

Template.vehicleFilter.onCreated ->
  @selectedGroupId = new ReactiveVar()
  @selectedFleetId = new ReactiveVar()
  @filter = new ReactiveVar()

Template.vehicleFilter.onRendered ->
  @subscribe 'fleetGroups'
  @autorun =>
    groupId = @selectedGroupId.get()
    @subscribe 'fleets', if groupId then parent: groupId else {}
    fleetId = @selectedFleetId.get()
    vehiclesFilter = if fleetId
        allocatedToFleet: fleetId
      else
        allocatedToFleet: $in: _.pluck(Fleets.find().fetch(), '_id')
    if filter = Session.get(@data.filterVar)?.trim()
      rx =
        $regex: filter
        $options: 'i'
      vehiclesFilter = _.extend vehiclesFilter, $or: [{name: rx}, {licensePlate: rx}, {identificationNumber: rx}, {tags: rx}]
    @subscribe 'vehicles', vehiclesFilter

Template.vehicleFilter.helpers
  options: -> @options
  displayVehiclesList: -> @options.vehicleDisplayStyle is 'list'
  displayVehiclesSelect: -> @options.vehicleDisplayStyle is 'select'
  fleetGroups: -> FleetGroups.find {}, sortByName
  fleets: ->
    groupId = Template.instance().selectedGroupId.get()
    filter = if groupId then parent: groupId else {}
    Fleets.find filter, sortByName
  vehicles: ->
    fleetId = Template.instance().selectedFleetId.get()
    filter = if fleetId
        allocatedToFleet: fleetId
      else
        allocatedToFleet: $in: _.pluck(Fleets.find().fetch(), '_id')
    Vehicles.find filter, sortByName
  active: -> if @_id is Session.get(Template.instance().data.selectedVehicleIdVar) then 'active' else ''
  tags: -> @tags?.split(",") || []

Template.vehicleFilter.events
  'change .vehicle-filter.fleet-group': (e, t) ->
    t.selectedGroupId.set t.$('.fleet-group').val()
  'change .vehicle-filter.fleet': (e, t) ->
    t.selectedFleetId.set t.$('.fleet').val()
  'change select.vehicle-filter.vehicle': (e, t) ->
    set @selectedVehicleIdVar, t.$('.vehicle').val()
  'click span.vehicle-filter.vehicle': (e, t) ->
    set Template.currentData().selectedVehicleIdVar, @_id
  'click .tag': (e, t) ->
    set Template.currentData().filterVar, @toString()
