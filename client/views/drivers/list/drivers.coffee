Template.drivers.onRendered ->
  Session.set 'selectedDriverId', null

Template.drivers.events
  'click .deleteDriver': ->
    Meteor.call 'removeDriver', Session.get('selectedDriverId')
    Session.set 'selectedDriverId', null
  'rowsSelected': (e, t) ->
    Session.set 'selectedDriverId', e.fleetrGrid.data[e.rowIndex]._id

Template.drivers.helpers
  selectedDriverId: -> Session.get('selectedDriverId')
  driversConfig: ->
    cursor: Drivers.find()
    columns: [
      id: "firstName"
      field: "firstName"
      name: "#{TAPi18n.__('drivers.firstName')}"
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "lastName"
      field: "name"
      name: "#{TAPi18n.__('drivers.name')}"
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "tags"    
      field: "tags"    
      name: "#{TAPi18n.__('drivers.tags')}"  
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

Template.columnTags.helpers   
  tagsArray: ->    
    (@value?.split(",") || []).map ((n) => value: n.trim(), grid: @grid, column: @column)    

Template.columnTags.events   
  'click .label': ->   
    @grid.setColumnFilterValue @column, @value