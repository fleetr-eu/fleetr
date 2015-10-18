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
    if Session.get(@data.filterVar)
      vehiclesFilter = _.extend vehiclesFilter,
        $text: $search: Session.get(@data.filterVar)
    @subscribe 'vehicles', vehiclesFilter

Template.vehicleFilter.helpers
  options: -> @options
  displayVehiclesAsList: -> @options.vehicleDisplayStyle is 'list'
  fleetGroups: -> FleetGroups.find {}, sortByName
  fleets: -> Fleets.find {}, sortByName
  vehicles: -> Vehicles.find {}, sortByName
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
