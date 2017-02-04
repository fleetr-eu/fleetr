aggregators = [
  new Slick.Data.Aggregators.Sum 'distance'
]

speeds = new ReactiveVar
selectedMonth = new ReactiveVar
speedsOption = new ReactiveVar

Template.fullLogbookReport.onRendered ->
  Meteor.call "analytics/month-vehicle-speed", (error, result) ->
    speeds.set result

  @autorun =>
    result = speeds.get()
    month = selectedMonth.get()
    if result
      month ?= Object.keys(result)[0]
      if (speedsOption.get())
        config =
          type: 'bar'
          data:
            labels: (r.vehicle for r in result[month])
            datasets: [
              label: 'Максимална Скорост (км/ч)'
              data: (r.maxSpeed for r in result[month])
              backgroundColor: 'rgba(230, 50, 50,1)'
            ,
              label: 'Средна Скорост (км/ч)'
              data: (r.avgSpeed for r in result[month])
              backgroundColor: 'rgba(50, 50, 230, 1)'
            ]
      else
        config =
          type: 'bar'
          data:
            labels: (r.vehicle for r in result[month])
            datasets: [
              label: 'Cкорост > 130 км/ч (брой)'
              data: (r.overspeeding for r in result[month])
              backgroundColor: 'rgba(230, 50, 50, 1)'
            ]

          options:
            scales:
              yAxes: [
                ticks:
                  min: 0
              ]

      $('#chart-container').empty()
      $('#chart-container').append('<canvas id="chart"><canvas>')
      ctx = document.getElementById("chart").getContext("2d")
      @chart = new Chart(ctx, config)


Template.fullLogbookReport.events
  'click a.speed-month': ->
    selectedMonth.set @
  'change #speedsOption': ->
    speedsOption.set true
  'change #overspeedingOption': ->
    speedsOption.set false

Template.fullLogbookReport.helpers
  months: ->
    if speeds?.get()
      Object.keys speeds.get()
    else []
  fleetrGridConfig: ->
    columns: [
      id: "date"
      field: "date"
      name: TAPi18n.__('time.date')
      width:30
      sortable: true
      search: where: 'client'
      groupable:
        aggregators: aggregators
    ,
      id: "fleetName"
      field: "fleetName"
      name: TAPi18n.__('fleet.title')
      width:50
      sortable: true
      search: where: 'client'
      groupable:
        aggregators: aggregators
    ,
      id: "vehicleName"
      field: "vehicleName"
      name: TAPi18n.__('vehicles.title')
      width:50
      sortable: true
      search: where: 'client'
      groupable:
        aggregators: aggregators
    ,
      id: 'Distance'
      name: TAPi18n.__('reports.logbook.distance')
      field: 'distance'
      formatter: (row, cell, value) -> Math.round(value)
      align: 'right'
      width: 40
      groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
    ,
      id: 'endOdometer'
      name: TAPi18n.__('reports.logbook.odometer')
      formatter: (row, cell, value) -> Math.round(value / 1000)
      field: 'endOdometer'
      align: 'right'
      width: 40
    ,
      id: 'maxSpeed'
      name: TAPi18n.__('reports.logbook.maxSpeed')
      field: 'maxSpeed'
      align: 'right'
      formatter: (row, cell, value) -> Math.round value
      width: 30
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    remoteMethod: 'fullLogbook'
