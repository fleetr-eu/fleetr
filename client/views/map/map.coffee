showFilterBox = new ReactiveVar false
showGeofences = new ReactiveVar false

Template.map.onRendered ->
  Session.set 'selectedVehicleId', @data.vehicleId
  position = Vehicles.findOne(_id: @data.vehicleId)?.selectedVehicle?.loc
  Map.init position, =>
    @autorun ->
      if showGeofences.get()
        Map.renderGeofences()
      else
        Map.removeGeofences()
    @autorun ->
      selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      if selectedVehicle
        Session.set 'fleetrTitle', "#{selectedVehicle.name} (#{selectedVehicle.licensePlate})"
        if selectedVehicle.lat && selectedVehicle.lon
          Map.setCenter [selectedVehicle.lat, selectedVehicle.lon]
        else
          Alerts.set 'This vehicle has no known position.'
      Map.renderMarkers()

      if selectedVehicle?.trip?.start
        searchArgs =
          recordTime:
            $gte: selectedVehicle.trip.start.time
          deviceId: selectedVehicle.unitId
          type: 30

        Meteor.subscribe 'logbook', searchArgs, ->
          points = Logbook.find searchArgs,
            sort: recordTime: -1,
            fields:
              lat: 1
              lon: 1

          points.observe
            added: ->
              Map.renderPath points.map (point) ->
                lat: point.lat, lng: point.lon, id: point._id

Template.map.helpers
  filterOptions: -> vehicleDisplayStyle: 'none'
  selectedVehicleId: -> Session.get('selectedVehicleId')
  showFilterBox: -> showFilterBox.get()
  showGeofences: -> showGeofences.get()

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
      formatter: FleetrGrid.Formatters.decoratedGreaterThanFormatter(50, 100, 0)
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

  'click #toggle-geofences': (e, t) ->
    showGeofences.set not showGeofences.get()

  'rowsSelected': (e, t) ->
    Session.set 'selectedVehicleId', e.fleetrGrid.data[e.rowIndex]?._id
