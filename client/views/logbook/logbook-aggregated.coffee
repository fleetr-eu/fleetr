Template.logbook.helpers
  vehicleName: -> Template.instance().data.vehicle.name
  fleetrGridConfig: ->
    remoteMethod: 'vehicle/history'
    remoteMethodParams: Template.instance().data.vehicle.unitId
    pagination: true
    columns: [
      id: 'date'
      name: 'Дата'
      field: 'date'
      width: 20
      sortable: true
    ,
      id: 'Distance'
      name: 'Разстояние (км)'
      field: 'distance'
      formatter: (row, cell, value) -> Math.round(value / 1000)
      align: 'right'
      width: 40
    ,
      id: 'endOdometer'
      name: 'Одометър (км в края на деня)'
      formatter: (row, cell, value) -> Math.round(value / 1000)
      field: 'endOdometer'
      align: 'right'
      width: 60
    ,
      id: 'maxSpeed'
      name: 'Макс. скорост (км/ч)'
      field: 'maxSpeed'
      align: 'right'
      formatter: (row, cell, value) -> Math.round value
      width: 50
    ,
      id: 'fuelExpenses'
      name: 'Гориво (лв с ДДС) / на 100км'
      field: 'expenses'
      align: 'right'
      formatter: (row, cell, value, column, rowObject) ->
        totalVATIncluded = if value?.fuels?.totalVATIncluded
          value.fuels.totalVATIncluded.toFixed(2)
        else ''
        per100km = if rowObject.distance and value?.fuels?.totalVATIncluded
          " / #{(value.fuels.totalVATIncluded / (rowObject.distance / 100000)).toFixed(2)}"
        else ''
        "#{totalVATIncluded}#{per100km}"
      width: 60
    ,
      id: 'fineExpenses'
      name: 'Глоби (лв с ДДС)'
      field: 'expenses'
      align: 'right'
      formatter: (row, cell, value, column, rowObject) ->
        if value?.fines?.totalVATIncluded
          value.fines.totalVATIncluded.toFixed(2)
        else ''
      width: 40
    ,
      id: 'simpleMapLink'
      field: 'date'
      name: 'М'
      maxWidth: 31
      align: 'center'
      formatter: (row, cell, value, column, rowObject) ->
        m = moment value
        q = encodeURIComponent EJSON.stringify
          deviceId: rowObject.deviceId
          start: time: m.startOf('day').valueOf()
          stop: time: m.endOf('day').valueOf()

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
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 30
    onInstall: (fleetrgrid) ->
      grid = fleetrgrid.grid
      grid.setSortColumn 'date', false
      fleetrgrid._performSort
        grid: grid
        multiColumnSort: false
        sortCols: [
          sortAsc: false
          sortCol: grid.getColumns()[grid.getColumnIndex 'date']
        ]
