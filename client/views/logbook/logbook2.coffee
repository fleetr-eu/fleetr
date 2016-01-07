showFilterBox = new ReactiveVar false

mapLinkFormatter = (row, cell, value) ->
  """
    <a href='/vehicles/map/#{value}'>
      <img src='/images/Google-Maps-icon.png' height='22'}'></img>
    </a>
  """
addressFormatter = (row, cell, value, column, rowObject) ->
  from = rowObject.start.address
  to = rowObject.stop.address
  if typeof from is 'object'
    """
      #{from?.city or ''}, #{from?.streetName or ''} #{from?.streetNumber or ''}
      <br />
      #{to?.city or ''}, #{to?.streetName or ''} #{to?.streetNumber or ''}
    """
  else
    """
      #{rowObject.start.address.replace('България, ', '').replace(/null/g, '')}
      <br />
      #{rowObject.stop.address.replace('България, ', '').replace(/null/g, '')}
    """

toTime = FleetrGrid.Formatters.timeFormatter
aggregators = [
  new Slick.Data.Aggregators.Sum 'distance'
  new Slick.Data.Aggregators.Sum 'consumedFuel'
]

Template.logbook2.events
  'click #toggle-filter': (e, t) ->
    showFilterBox.set not showFilterBox.get()
    Meteor.defer -> t.grid.resize()
  'change #logbookVehicleFilter': (e, t) ->
    Router.go 'vehicleLogbook', vehicleId: e.target.value
  'rowsSelected': (e, t) ->
    Router.go 'vehicleLogbook', vehicleId: e.fleetrGrid.data[e.rowIndex]._id
    # Session.set 'selectedVehicleId', e.fleetrGrid.data[e.rowIndex]._id
  'change input[name="dateFilter"]': (e, t) ->
    Session.set 'logbookDateFilterPeriod', e.target.id

Template.logbook2.onRendered ->
  Session.set 'selectedVehicleId', Template.instance().data.vehicleId
  Session.set 'logbookDateFilterPeriod', 'week'

Template.logbook2.helpers
  vehicleName: ->
    # v = Vehicles.findOne(_id: Session.get('selectedVehicleId'))
    v = Vehicles.findOne(_id: Template.instance().data.vehicleId)
    "#{v.name} (#{v.licensePlate})"
  filterOptions: -> vehicleDisplayStyle: 'none'
  selectedVehicleId: -> Session.get('selectedVehicleId')
  showFilterBox: -> showFilterBox.get()

  filterVehiclesGridConfig: ->
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

    cursor: Vehicles.find {}, sort: name: 1

  fleetrGridConfig: ->
    v = Vehicles.findOne(_id: Template.instance().data.vehicleId)
    cursor: -> Trips.find
      deviceId: v.unitId
      'start.time': $gte: moment().startOf(Session.get('logbookDateFilterPeriod')).toDate()
    ,
      transform: (doc) -> _.extend doc,
          fuelPer100: doc.consumedFuel / (doc.distance / 100)
    columns: [
      id: "date"
      field: "date"
      name: "Дата"
      width: 35
      sortable: true
      groupable:
        aggregators: aggregators
    ,
      id: 'fromTo'
      name: 'От / До'
      field: 'start.time'
      sortable: true
      formatter: (row, cell, value, column, rowObject) ->
        """
          #{toTime(row, cell, rowObject.start?.time)}
          <br />
          #{toTime(row, cell, rowObject.stop?.time)}
        """
      sort: (args) -> (a,b) ->
        if a.start?.time > b.start?.time then 1 else -1
      width: 35
    ,
      id: 'beginEnd'
      name: 'Старт / Финиш'
      formatter: addressFormatter
      width: 80
      search: where: 'client'
    ,
      id: 'distance'
      field: 'distance'
      name: 'Разстояние'
      formatter: FleetrGrid.Formatters.roundFloat 2
      width: 20
      align: 'right'
      groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
    ,
      id: 'fuel'
      field: 'consumedFuel'
      name: 'Гориво / на 100км'
      formatter: (row, cell, value, column, rowObject) ->
        fc = FleetrGrid.Formatters.roundFloat(2) row, cell, rowObject.consumedFuel/1000
        fp100 = FleetrGrid.Formatters.roundFloat(2) row, cell, rowObject.fuelPer100/1000
        "#{fc or ''}<br />#{fp100 or ''}"
      width: 30
      align: 'right'
      groupTotalsFormatter: (totals, columnDef) ->
        val = totals.sum && totals.sum[columnDef.field]
        if val
          "<b>#{(Math.round(parseFloat(val)*100)/100)/1000}</b>"
        else ''
    ,
      id: 'speed'
      field: 'avgSpeed'
      name: 'Скорост / Макс'
      formatter: (row, cell, value, column, rowObject) ->
        s = if rowObject.avgSpeed
          FleetrGrid.Formatters.roundFloat(0)(row, cell, rowObject.avgSpeed)
        else ''
        ms = if rowObject.maxSpeed
          FleetrGrid.Formatters.roundFloat(0)(row, cell, rowObject.maxSpeed)
        else ''
        "#{s}<br />#{ms}"
      width: 30
      cssClass: 'from'
      align: 'right'
    ,
      id: 'simpleMapLink'
      field: 'deviceId'
      name: 'М'
      maxWidth: 31
      align: 'center'
      formatter: (row, cell, value, column, rowObject) ->
        q = encodeURIComponent EJSON.stringify
          deviceId: value
          start:
            time: moment(rowObject.start?.time).valueOf()
            position:
              lat: rowObject.start.lat
              lng: rowObject.start.lng
          stop:
            time: moment(rowObject.stop?.time).valueOf()
            position:
              lat: rowObject.stop.lat
              lng: rowObject.stop.lng

        """
        <a href='/map/#{q}'>
          <img src='/images/Google-Maps-icon.png' height='22'/>
        </a>
        """
    ]
    options:
      enableCellNavigation: false
      enableColumnReorder: false
      showHeaderRow: false
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 50
