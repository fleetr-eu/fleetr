Template.tyres.helpers
  options: ->
    i18nRoot: 'tyre'
    collection: Tyres
    editItemTemplate: 'tyre'
    removeItemMethod: 'removeTyre'
    gridConfig:
      columns: [
        id: "active"
        field: "active"
        name: TAPi18n.__ 'tyre.active'
        width:20
        sortable: true
        search: false
        align: 'center'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.activeTyre
      ,
        id: "vehicle"
        field: "vehicleLicensePlate"
        name: TAPi18n.__ 'tyre.vehicle'
        width:20
        sortable: true
        search: where: 'client'
      ,
        id: "width"
        field: "width"
        name: TAPi18n.__ 'tyre.width'
        width:20
        sortable: true
        search: where: 'client'
      ,
        id: "height"
        field: "height"
        name: TAPi18n.__ 'tyre.height'
        width:20
        sortable: true
        search: where: 'client'
      ,
        id: "innerDiameter"
        field: "innerDiameter"
        name: TAPi18n.__ 'tyre.innerDiameter'
        width:20
        sortable: true
        search: where: 'client',
      ,
        id: "loadIndex"
        field: "loadIndex"
        name: TAPi18n.__ 'tyre.loadIndex'
        width:20
        sortable: true
        search: where: 'client',
      ,
        id: "speedIndex"
        field: "speedIndex"
        name: TAPi18n.__ 'tyre.speedIndex'
        width:20
        sortable: true
        search: where: 'client',
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Tyres.find {},
        transform: (doc) -> _.extend doc,
          vehicleLicensePlate: Vehicles.findOne(_id: doc.vehicle)?.licensePlate
