TabularTables = {}

Meteor.isClient && Template.registerHelper('TabularTables', TabularTables)

TabularTables.Drivers = new Tabular.Table
  name: "DriversList",
  collection: Drivers,
  columns: [
    {data: "firstName", title: "Name"},
    {data: "name", title: "Sirname"}
  ]

TabularTables.RecLog = new Tabular.Table
  name: "RecLog",
  collection: Logbook,
  columns: [
    {title: 'Time' , sort: 'descending', data: (obj)->
      moment(obj.recordTime).zone(Settings.unitTimezone).format('DD-MM HH:mm:ss')
    }
    {title: 'Type', data: 'type'}
    {title: 'Distance', data: (obj)-> obj.distance?.toFixed(2)}
#     {key: 'tacho', label: 'Odo', fn: (val,obj)->
#       km = Math.floor(val/1000)
#       m = val%1000
#       km + ',' + m
#     }
    {title: 'Speed', data: (obj)-> obj.speed}
    {title: 'Interval', data: (obj)-> obj.interval}
  ]
  rowCallback: (row,data)->
    console.log 'Row: ' + row + ' data: ' + data.type
    rowClass = (item)->
      return 'regular-row' if item.type == 30
      return 'event-row' if item.type == 35
      if item.type == 29
        return if item.io%2 == 0 then 'stop-row' else 'start-row'
      'unknown'
    row.setAttribute('class', rowClass(data))
