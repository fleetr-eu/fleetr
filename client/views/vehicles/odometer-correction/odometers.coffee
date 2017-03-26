Template.odometers.onRendered ->
  vehicleId = @data.vehicleId
  Template.odometer.onRendered ->
    @vehicleId = vehicleId

  Template.odometer.helpers
    vehicleId: vehicleId

mToKmFormatter = (row, cell, value) ->
  if value then Math.round(value / 1000) else 0

Template.odometers.helpers
  vehicleName: ->
    Vehicles.findOne(_id: @vehicleId)?.displayName()
  options: ->
    i18nRoot: 'vehicles.odometers'
    collection: Odometers
    editItemTemplate: 'odometer'
    removeItemMethod: 'removeOdometer'
    gridConfig:
      cursor: Odometers.find()
      columns: [
        id: "date"
        field: "dateTime"
        name: TAPi18n.__('vehicles.odometers.date')
        width:40
        sortable: true
        formatter: FleetrGrid.Formatters.dateTimeFormatter
        search: where: 'client'
      ,
        id: "value"
        field: "value"
        name: TAPi18n.__('vehicles.odometers.value')
        formatter: mToKmFormatter
        width: 80
      ,
        id: "oldValue"
        field: "oldValue"
        name: TAPi18n.__('vehicles.odometers.oldValue')
        formatter: mToKmFormatter
        width: 80
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
