@TabularTables = {}

# Meteor.isClient && Template.registerHelper('TabularTables', TabularTables)

TabularTables.Logbook = new Tabular.Table 
  name: "Logbook"
  collection: Logbook
  columns: [
    {data: "lat", title: "Lat"}
    {data: "lon", title: "Lon"}
    {data: "speed", title: "Speed"}
  ]
  # selector: () -> {type:30}
console.log 'Table defined'



