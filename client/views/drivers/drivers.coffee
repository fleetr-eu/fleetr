Template.drivers.helpers
  options: ->
    i18nRoot: 'drivers'
    collection: Fleets
    editItemTemplate: 'driver'
    removeItemMethod: 'removeDriver'
    gridConfig:
      columns: [
        id: "firstName"
        field: "firstName"
        name: "#{TAPi18n.__('drivers.firstName')}"
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "lastName"
        field: "lastName"
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
      cursor: Drivers.find()
