showFilterBox = new ReactiveVar false

Template.map.onRendered ->
  Session.set 'selectedVehicleId', @data.vehicleId
  @autorun =>
    @selectedVehicle = Vehicles.findOne {_id: Session.get('selectedVehicleId')},
      fields:
        name: 1
        licensePlate: 1
    if @selectedVehicle
      Session.set 'fleetrTitle',
        "#{@selectedVehicle.name} (#{@selectedVehicle.licensePlate})"


Template.map.helpers
  filterOptions: -> vehicleDisplayStyle: 'none'
  selectedVehicleId: -> Session.get('selectedVehicleId')
  showFilterBox: -> showFilterBox.get()

  fleetrGridConfig: ->
    columns: [
      id: "status"
      field: "state"
      name: ""
      width: 1
      sortable: true
      search: where: 'client'
      formatter: FleetrGrid.Formatters.statusFormatter
    ,
      id: "speed"
      field: "speed"
      name: TAPi18n.__('vehicles.speed')
      width: 40
      sortable: true
      align: 'right'
      search: where: 'client'
      formatter: FleetrGrid.Formatters.decoratedGreaterThanFormatter(120, 110, 0)
    ,
      id: "name"
      field: "name"
      name: TAPi18n.__('vehicles.name')
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "licensePlate"
      field: "licensePlate"
      name: TAPi18n.__('vehicles.licensePlate')
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "tags"
      field: "tags"
      name: TAPi18n.__('vehicles.tags')
      hidden: true
      width:80
      sortable: true
      search: where: 'client'
      formatter: FleetrGrid.Formatters.blazeFormatter Template.columnTags
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    onCreated: ((tpl) -> (grid) ->
      tpl.grid = grid
    )(Template.instance())

    cursor: Vehicles.find {}, sort: name: 1


Template.map.events
  'click #toggle-filter': (e, t) ->
    showFilterBox.set not showFilterBox.get()
    Meteor.defer -> t.grid?.resize()

  'rowsSelected': (e, t) ->
    unless e.rowIndex is -1
      Session.set 'selectedVehicleId', e.fleetrGrid.getItemByRowId(e.rowIndex)?._id
