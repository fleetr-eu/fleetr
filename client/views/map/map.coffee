Template.map.onCreated ->
  @showFilterBox = new ReactiveVar false

Template.map.onRendered ->
  Session.set 'selectedVehicleId', @data.vehicleId
  mapCanvasHeight = $(document).height() - 230
  $('#map-canvas').height mapCanvasHeight
  Map.init =>
    @autorun ->
      selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      if selectedVehicle
        if selectedVehicle.lat && selectedVehicle.lon
          Map.setCenter [selectedVehicle.lat, selectedVehicle.lon]
        else
          Alerts.set 'This vehicle has no known position.'

    @autorun -> Map.renderMarkers(); Session.get 'vehicleFilter'

Template.map.helpers
  filterOptions: -> vehicleDisplayStyle: 'none'
  selectedVehicleId: -> Session.get('selectedVehicleId')
  filterSize: -> if Template.instance().showFilterBox.get() then 'col-md-4' else 'hidden'
  mapSize: -> if Template.instance().showFilterBox.get() then 'col-md-8' else 'col-md-12'

  fleetrGridConfig: ->
    columns: [
      id: "name"
      field: "name"
      name: "Name"
      width:120
      sortable: true
      search: where: 'client'
    ,
      id: "licensePlate"
      field: "licensePlate"
      name: "License Plate"
      width:120
      sortable: true
      search: where: 'client'
    ,
      id: "tags"
      field: "tags"
      name: "Tags"
      width:120
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
  'click #pac-input-clear': -> $('#pac-input').val('')
  'click #toggle-filter': (e, t) ->
    t.showFilterBox.set not t.showFilterBox.get()
    Meteor.defer -> t.grid.resize()

  'rowsSelected': (e, t) ->
    Session.set 'selectedVehicleId', e.fleetrGrid.data[e.rowIndex]._id
