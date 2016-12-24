aggregators = [
  new Slick.Data.Aggregators.Sum 'distance'
]

Template.fullLogbookReport.onRendered ->
  
  Meteor.call "analytics/month-vehicle-speed", (error, result) ->
    console.log(result)
    config =  
      type: 'bar'
      data: 
        labels: (r.vehicle for r in result['2016-12'])
        datasets: [
          label: 'Максимална скорост'
          data: (r.maxSpeed for r in result['2016-12']).map(Math.round)
          backgroundColor: 'rgba(220,99,132,1)'
        ,
          label: 'Средна скорост'
          data: (r.avgSpeed for r in result['2016-12']).map(Math.round)
          backgroundColor: 'rgba(54, 162, 235, 1)'
        ]  

      options: 
        scales: 
          yAxes: [
            ticks: 
              min: 0
          ]

    ctx = document.getElementById("chart").getContext("2d")
    window.myLine = new Chart(ctx, config)
  
Template.fullLogbookReport.helpers
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
