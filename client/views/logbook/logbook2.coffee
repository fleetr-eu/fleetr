showFilterBox = new ReactiveVar false

mapLinkFormatter = (row, cell, value) ->
  """
    <a href='/vehicles/map/#{value}'>
      <img src='/images/Google-Maps-icon.png' height='22'}'></img>
    </a>
  """
addressFormatter = (row, cell, value, column, rowObject) ->
  from = rowObject.startAddress
  to = rowObject.stopAddress
  address = """
    #{from or ''}
    <br />
    #{to or ''}
  """

toTime = FleetrGrid.Formatters.timeFormatter
aggregators = [
  new Slick.Data.Aggregators.Sum 'distance'
  new Slick.Data.Aggregators.Sum 'consumedFuel'
  new Slick.Data.Aggregators.Sum 'duration'
]

Template.logbook2.events
  'click #toggle-filter': (e, t) ->
    showFilterBox.set not showFilterBox.get()
    Meteor.defer -> t.grid?.resize()
  'change #logbookVehicleFilter': (e, t) ->
    Router.go 'vehicleLogbook', vehicleId: e.target.value
  'rowsSelected': (e, t) ->
    unless e.rowIndex is -1
      Router.go 'vehicleLogbook', vehicleId: e.fleetrGrid.getItemByRowId(e.rowIndex)?._id
  'change input[name="dateFilter"]': (e, t) ->
    Session.set 'logbookDateFilterPeriod', e.target.id

Template.logbook2.onCreated ->
  vid = Template.instance().data.vehicleId
  Session.set 'selectedVehicleId', vid
  Session.set 'logbookDateFilterPeriod', 'year'

Template.logbook2.helpers
  vehicle: -> Vehicles.findOne(_id: Template.instance().data.vehicleId)
  filterOptions: -> vehicleDisplayStyle: 'none'
  selectedVehicleId: -> Session.get('selectedVehicleId')
  showFilterBox: -> showFilterBox.get()
  timeRange: -> console.log Session.get 'logbookDateFilterPeriod'; Session.get 'logbookDateFilterPeriod'

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

Template.logbookGrid.helpers
  fleetrGridConfig: ->
    remoteMethod: 'vehicle/trips'
    remoteMethodParams: Template.instance().data
    columns: [
      id: "date"
      field: "date"
      name: "Дата"
      maxWidth: 90
      sorted: 'desc'
      sortable: true
      groupable:
        aggregators: aggregators
        headerFormatter: (group, defaultFormatter) ->
          ids = group.rows.map (item) -> item._id
          "#{defaultFormatter()}<div style='float:right'><a href='#'><img src=\"/images/Google-Maps-icon.png\" height=\"22\" /></a></div>"
    ,
      id: 'fromTo'
      name: 'От / До'
      field: 'startTime'
      sortable: true
      formatter: (row, cell, value, column, rowObject) ->
        """
          #{toTime(row, cell, rowObject.startTime)}
          <br />
          #{toTime(row, cell, rowObject.stopTime)}
        """
      sorter: (sortCol) -> (a,b) ->
        if a.start?.time > b.start?.time then 1 else -1
      maxWidth: 80
    ,
      id: 'beginEnd'
      name: 'Старт / Финиш'
      formatter: addressFormatter
      width: 80
      search: where: 'client'
    ,
      id: 'distance'
      field: 'distance'
      name: 'Разстояние (км)'
      formatter: FleetrGrid.Formatters.roundFloat 2
      width: 20
      align: 'right'
      search:
        where: 'client'
        filter: (filterText) -> (columnValue) ->
          if columnValue >= parseFloat(filterText) then columnValue else ''
      groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
    ,
      id: 'duration'
      field: 'duration'
      name: 'Продължителност'
      formatter: (row, cell, value, column, rowObject) ->
        moment.duration(moment(rowObject.stopTime).diff(rowObject.startTime)).humanize()
      width: 20
      search:
        where: 'client'
        filter: (filterText) -> (columnValue) ->
          if moment.duration(columnValue, 'minutes') >= parseInt(filterText) then columnValue else ''
      align: 'right'
      groupTotalsFormatter: (totals, columnDef) ->
        val = totals.sum && totals.sum[columnDef.field]
        if val
          "<b>#{moment.duration(val, 'seconds').humanize()}</b>"
        else ''
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
      search:
        where: 'client'
        filter: (filterText) -> (columnValue) ->
          if columnValue >= parseFloat(filterText) then columnValue else ''
      groupTotalsFormatter: (totals, columnDef) ->
        val = totals.sum && totals.sum[columnDef.field]
        if val
          "<b>#{(Math.round(parseFloat(val)*100)/100)/1000}</b>"
        else ''
    ,
      id: 'speed'
      field: 'maxSpeed'
      name: 'Скорост / Макс (км/ч)'
      search:
        where: 'client'
        filter: (filterText) -> (columnValue) ->
          if columnValue >= parseInt(filterText) then columnValue else ''
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
      field: '_id'
      name: 'М'
      maxWidth: 31
      align: 'center'
      formatter: (row, cell, value, column, rowObject) ->
        q = encodeURIComponent EJSON.stringify
          tripId: value
          deviceId: rowObject.deviceId
          start:
            time: moment(rowObject.startTime).valueOf()
            position:
              lat: rowObject.startLat
              lng: rowObject.startLng
          stop:
            time: moment(rowObject.stopTime).valueOf()
            position:
              lat: rowObject.stopLat
              lng: rowObject.stopLng

        """
        <a href='/map/#{q}'>
          <img src='/images/Google-Maps-icon.png' height='22'/>
        </a>
        """
    ]
    options:
      multiColumnSort: true
      enableCellNavigation: false
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 50
    customize: (grid) ->
      grid.addGroupBy 'date', 'Дата', aggregators
