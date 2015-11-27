Template.vehicles.helpers
  options: ->
    i18nRoot: 'vehicles'
    collection: Vehicles
    editItemTemplate: 'vehicle'
    removeItemMethod: 'removeVehicle'
    gridConfig:
      columns: [
        id: "fleetName"
        field: "fleetName"
        name: "#{TAPi18n.__('fleet.name')}"
        width:80
        sortable: true
        hidden:true
        search: where: 'client'
        groupable:
          aggregators: []
      ,
        id: "name"
        field: "name"
        name: "#{TAPi18n.__('vehicles.name')}"
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "licensePlate"
        field: "licensePlate"
        name: "#{TAPi18n.__('vehicles.licensePlate')}"
        width:50
        sortable: true
        search: where: 'client'
      ,
        id: "unitId"
        field: "unitId"
        name: "#{TAPi18n.__('vehicles.unitId')}"
        width:50
        sortable: true
        search: where: 'client'
      , 
        id: "phoneNumber"
        field: "phoneNumber"
        name: "#{TAPi18n.__('vehicles.phoneNumber')}"
        width:50
        sortable: true
        search: where: 'client'
      , 
        id: "odometer"
        field: "odometer"
        name: "#{TAPi18n.__('vehicles.odometer')}"
        width:50
        sortable: true
        search: where: 'client'
      ,       
        id: "tags"
        field: "tags"
        name: "#{TAPi18n.__('vehicles.tags')}"
        width:100
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
      cursor: Vehicles.find {},
        transform: (doc) -> _.extend doc, 
            fleetName: Fleets.findOne(_id: doc.allocatedToFleet)?.name
