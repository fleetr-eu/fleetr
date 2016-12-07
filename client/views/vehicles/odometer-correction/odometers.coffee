Template.odometers.onRendered ->
  vehicleId = @data.vehicleId
  console.log vehicleId
  Template.odometer.onRendered ->
    @vehicleId = vehicleId
  Template.odometer.helpers
    vehicleId: vehicleId

Template.odometers.helpers
  options: ->
    i18nRoot: 'vehicles.odometers'
    collection: Odometers
    editItemTemplate: 'odometer'
    removeItemMethod: 'removeOdometer'
    gridConfig:
      cursor: Odometers.find()
      columns: [
        id: "date"
        field: "date"
        name: TAPi18n.__('vehicles.odometers.date')
        width:40
        sortable: true
        search: where: 'client'
      ,
        id: "value"
        field: "value"
        name: TAPi18n.__('vehicles.odometers.value')
        width: 80
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
