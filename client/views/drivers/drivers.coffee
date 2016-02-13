Template.documentsButton.helpers
  driverId: => Session.get "selectedItemId"

Template.drivers.helpers
  options: ->
    i18nRoot: 'drivers'
    collection: Drivers
    editItemTemplate: 'driver'
    removeItemMethod: 'removeDriver'
    additionalItemActionsTemplate: 'documentsButton'
    gridConfig:
      columns: [
        id: "firstName"
        field: "firstName"
        name: "#{TAPi18n.__('drivers.firstName')}"
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "name"
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
        search:
          where: 'client'
          filter: (search) -> (item) ->
            _.contains item.split(',').map((e)->e.trim()), search
        formatter: FleetrGrid.Formatters.blazeFormatter Template.columnTags
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Drivers.find()
