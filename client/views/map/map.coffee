statusFormatter = () -> (row, cell, value) ->
  if value
    if value == "stop"
      "<img src='/images/truck-state-blue.png'}'></img> "
    else
      if value == "start"
        "<img src='/images/truck-state-green.png'}'></img> "  
      else          
        "<img src='/images/truck-state-grey.png'}'></img> "
  else          
    "<img src='/images/truck-state-grey.png'}'></img> "  

showFilterBox = new ReactiveVar false

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
  showFilterBox: -> showFilterBox.get()

  fleetrGridConfig: ->
    columns: [
      id: "status"
      field: "status"
      name: ""
      width: 1
      sortable: true
      search: where: 'client'
      formatter: statusFormatter()
    ,
      id: "speed"
      field: "speed"
      name: TAPi18n.__('vehicles.speed')
      width: 40
      sortable: true
      align: 'right'
      search: where: 'client'
      formatter: FleetrGrid.Formatters.roundFloat(2)
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
  'click #pac-input-clear': -> $('#pac-input').val('')
  'click #toggle-filter': (e, t) ->
    showFilterBox.set not showFilterBox.get()
    Meteor.defer -> t.grid.resize()

  'rowsSelected': (e, t) ->
    Session.set 'selectedVehicleId', e.fleetrGrid.data[e.rowIndex]._id
