hiddenOnMobile = () ->
  Session.get('device-screensize') is 'small'

timeAgoFormatter = (row, cell, value) ->
  attnIcon =""
  vStr = ""
  formattedValue = moment(value).format(Settings.shortDateTimeFormat)
  if value then vStr = moment(value).from(moment())
  hoursAgo = moment().diff(moment(value), "hours")
  if hoursAgo > 1
      attnIcon =  "<i class='fa fa-exclamation-triangle pull-left' style='color:orange; padding-top:3px;' title='#{formattedValue}'></i>"
  if hoursAgo > 24
      attnIcon = "<i class='fa fa-exclamation-triangle pull-left' style='color:red; padding-top:3px;' title='#{formattedValue}'></i>"
  "<span>#{attnIcon}<div>#{vStr}</div></span>"


linkFormatter = (report) -> (row, cell, value) ->
  "<a href='/vehicles/#{value}/#{report}' style='background-color:#000'><img src='/images/#{report}-icon.png' height='22' }'></img></a>"

linkLoogbookFormatter = (report, minDistance) -> (row, cell, value) ->
  "<a href='/vehicles/#{value}/#{report}'><img src='/images/#{report}-icon.png' height='22' }'></img></a>"

mapLinkFormatter = (row, cell, value) ->
  "<a href='/vehicles/map/#{value}'><img src='/images/Google-Maps-icon.png' height='22'}'></img></a>"

Template.vehicles.onRendered ->
  Session.set 'vehiclesFleetName', @data.fleetName

Template.vehicles.events
  'fleetr-grid-removed-filter': (e, t) ->
    if e.filter.name is TAPi18n.__('fleet.name')
      Session.set 'vehiclesFleetName', null

Template.vehicle.helpers

  dayOfWeek: (dayOfWeek) ->
    moment().locale('bg').isoWeekday(parseInt(dayOfWeek.split('.')[1])+1).format('dddd')

Template.vehicles.helpers

  options: ->
    i18nRoot: 'vehicles'
    collection: Vehicles
    editItemTemplate: 'vehicle'
    removeItemMethod: 'removeVehicle'
    gridConfig:
      pagination: false
      columns: [
        id: "state"
        field: "state"
        name: TAPi18n.__('vehicles.stateShort')
        maxWidth: 38
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.statusFormatter
        align: 'left'
      ,
        id: "speed"
        field: "speed"
        name: TAPi18n.__('vehicles.speedShort')
        maxWidth: 70
        sortable: true
        align: 'right'
        search: where: 'client'
        formatter: FleetrGrid.Formatters.decoratedGreaterThanFormatter(130, 115, 0)
      ,
        id: "fleetName"
        field: "fleetName"
        name: TAPi18n.__('fleet.name')
        width:80
        sortable: true
        # hidden:true
        search: where: 'client'
        groupable:
          aggregators: []
      ,
        id: "vehicleShowName"
        field: "vehicleShowName"
        name: TAPi18n.__('vehicles.name')
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "driverName"
        field: "driverName"
        name: TAPi18n.__('vehicles.driverName')
        width:100
        hidden: hiddenOnMobile()
        sortable: true
        search: where: 'client'
      # ,
      #   id: "unitId"
      #   field: "unitId"
      #   name: TAPi18n.__('vehicles.unitId')
      #   width: 50
      #   hidden: true
      #   sortable: true
      #   search: where: 'client'
      #   hidden:true
      # ,
      #   id: "phoneNumber"
      #   field: "phoneNumber"
      #   name: TAPi18n.__('vehicles.phoneNumber')
      #   width: 50
      #   hidden: true
      #   sortable: true
      #   search: where: 'client'
      ,
        id: "odometer"
        field: "odo"
        name: TAPi18n.__('vehicles.odometer')
        width:50
        align: 'right'
        sortable: true
        hidden: hiddenOnMobile()
        search: where: 'client'
        formatter: FleetrGrid.Formatters.roundFloat(0)
      ,
        id: "lastUpdate"
        field: "lastUpdate"
        name: TAPi18n.__('vehicles.lastUpdate')
        width:60
        sortable: true
        formatter: timeAgoFormatter
        hidden: hiddenOnMobile()
        search: where: 'client'
      ,
        id: "map"
        field: "_id"
        name: TAPi18n.__('vehicles.mapShort')
        maxWidth: 31
        formatter: mapLinkFormatter
        align: 'left'
      ,
        id: "logbook"
        field: "_id"
        name: TAPi18n.__('vehicles.logbookShort')
        maxWidth: 31
        formatter:  linkLoogbookFormatter('logbook', 0.05)
        align: 'left'
      ,
        id: "history"
        field: "_id"
        name: TAPi18n.__('vehicles.historyShort')
        maxWidth: 31
        formatter: linkFormatter 'history'
        align: 'left'
      ,
        id: "tags"
        field: "tags"
        name: TAPi18n.__('vehicles.tags')
        width:60
        sortable: true
        hidden: hiddenOnMobile()
        search: where: 'client'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.columnTags
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: -> Vehicles.find {},
        sort:
          name: 1
        transform: (doc) ->
          driver = Drivers.findOne(_id: doc.driver_id)
          _.extend doc,
            fleetName: Fleets.findOne(_id: doc.allocatedToFleet)?.name
            driverName: if driver then driver.firstName + " " + driver.name else ""
            vehicleShowName: doc.name + ' (' + doc.licensePlate + ')'
            odo: doc.odometer / 1000
            isBusinessTrip: isBusinessTrip(doc, moment())
      customize: (grid) ->
        Meteor.defer ->
          Tracker.autorun ->
            fleetName = Session.get 'vehiclesFleetName'
            if fleetName
              grid.setColumnFilterValue {id: 'fleetName'}, fleetName
            else
              grid.removeFilter 'client', TAPi18n.__('fleet.name')
