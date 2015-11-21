Template.tyres.helpers
  options: ->
    i18nRoot: 'tyre'
    collection: Tyres
    editItemTemplate: 'tyre'
    removeItemMethod: 'removeTyre'
    gridConfig:
      columns: [
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
      cursor: Tyres.find()
