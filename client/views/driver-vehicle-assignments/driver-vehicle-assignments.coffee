Template.driverVehicleAssignments.helpers
  options: ->
    i18nRoot: 'driverVehicleAssignments'
    collection: DriverVehicleAssignments
    editItemTemplate: 'driverVehicleAssignment'
    removeItemMethod: 'removeDriverVehicleAssignment'
    gridConfig:
      columns: [
        id: "driverName"
        field: "driverName"
        name: "#{TAPi18n.__('driverVehicleAssignments.driverName')}"
        width:80
        sortable: true
        groupable:
          aggregators: []
        search: where: 'client'
      ,
        id: "vehicleName"
        field: "vehicleName"
        name: "#{TAPi18n.__('driverVehicleAssignments.vehicleName')}"
        width:80
        groupable:
          aggregators: []
        sortable: true
        search: where: 'client'
      ,
        id: "date"
        field: "date"
        name: "#{TAPi18n.__('driverVehicleAssignments.date')}"
        width:50
        sortable: true
        search: 
          where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "time"
        field: "time"
        name: "#{TAPi18n.__('driverVehicleAssignments.time')}"
        width:50
        sortable: true
        search: 
          where: 'client'
      ,
        id: "eventName"
        field: "eventName"
        name: "#{TAPi18n.__('driverVehicleAssignments.event')}"
        width:50
        sortable: true
        search: where: 'client'      
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: DriverVehicleAssignments.find {},
        transform: (doc) -> _.extend doc,
          vehicleName : Vehicles.findOne(_id: doc.vehicle)?.name + ' ('+Vehicles.findOne(_id: doc.vehicle)?.licensePlate+')',
          driverName : Drivers.findOne(_id: doc.driver)?.firstName + ' ('+Drivers.findOne(_id: doc.driver)?.name+')'
          eventName: if doc.event is'begin' then "#{TAPi18n.__('driverVehicleAssignments.associate')}" else "#{TAPi18n.__('driverVehicleAssignments.disassociate')}"

