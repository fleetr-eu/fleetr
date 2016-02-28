showFilterBox = new ReactiveVar false
showGeofences = new ReactiveVar false

Template.map.onRendered ->
  Session.set 'selectedVehicleId', @data.vehicleId
  # position = Vehicles.findOne(_id: @data.vehicleId)?.selectedVehicle?.loc

  @map = new FleetrMap '#map-canvas',
    showVehicles: true

  @autorun =>
    if showGeofences.get()
      @geofences = {}
      map = @map.map
      Geofences.find().observe
        added: (gf) =>
          @geofences[gf._id] = new Geofence gf, map
        removed: (gf) =>
          @geofences[gf._id].destroy()
          delete @geofences[gf._id]
        changed: (gf) =>
          @geofences[gf._id].destroy()
          delete @geofences[gf._id]
          @geofences[gf._id] = new Geofence gf, map
    else
      gf.destroy() for id, gf of @geofences
      @geofences = []


  @autorun =>
    if @selectedVehicle?._id isnt Session.get('selectedVehicleId')
      @map.removeCurrentPath()
      @selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      console.log 'vehicle', @selectedVehicle.trip?.path
      if @selectedVehicle
        Session.set 'fleetrTitle',
          "#{@selectedVehicle.name} (#{@selectedVehicle.licensePlate})"
        if @selectedVehicle.lat && @selectedVehicle.lon
          @map.map.setCenter
            lat: @selectedVehicle.lat
            lng: @selectedVehicle.lon
        else
          Alerts.set 'This vehicle has no known position.'



      # if @selectedVehicle?.trip?.start
      #   searchArgs = (startTime = {$gte: @selectedVehicle.trip.start.time}) =>
      #     deviceId: @selectedVehicle.unitId
      #     type: 30
      #     recordTime: startTime
      #
      #   options =
      #     sort: recordTime: 1
      #     fields:
      #       lat: 1
      #       lon: 1
      #
        # Meteor.subscribe 'logbook', searchArgs(), options, =>
        #   addPointToPath = (point) =>
        #     @map.extendCurrentPath new google.maps.LatLng
        #       lat: point.lat, lng: point.lon, id: point._id
        #
        #   currentPoints = Logbook.find searchArgs(), options
        #   currentPoints.map addPointToPath
        #
        #   @pathObserver?.stop()
        #   # futurePoints = Vehicles.find {_id: @selectedVehicle._id},
        #   #   fields:
        #   #     lat: 1
        #   #     lon: 1
        #   futurePoints = Logbook.find searchArgs({$gt: new Date()}), options
        #   @pathObserver = futurePoints.observe
        #     added: (point) -> console.log point; addPointToPath point

Template.map.helpers
  filterOptions: -> vehicleDisplayStyle: 'none'
  selectedVehicleId: -> Session.get('selectedVehicleId')
  showFilterBox: -> showFilterBox.get()
  showGeofences: -> showGeofences.get()
  selectedVehiclePath: ->
    selectedVehicle = Vehicles.findOne {_id: Session.get('selectedVehicleId')},
      fields: trip: 1
    map = Template.instance().map
    map?.renderPath selectedVehicle?.trip?.path or []
    ''

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
  'click #pac-input-clear': -> $('#pac-input').val('')

  'click #toggle-filter': (e, t) ->
    showFilterBox.set not showFilterBox.get()
    Meteor.defer -> t.grid.resize()

  'click #toggle-geofences': (e, t) ->
    showGeofences.set not showGeofences.get()

  'rowsSelected': (e, t) ->
    Session.set 'selectedVehicleId', e.fleetrGrid.data[e.rowIndex]?._id
