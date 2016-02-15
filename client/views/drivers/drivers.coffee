hiddenOnMobile = () ->
  Session.get('device-screensize') is 'small'

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
        id: "fullName"
        field: "fullName"
        name: "#{TAPi18n.__('drivers.fullName')}"
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "fullAddress"
        field: "fullAddress"
        name: "#{TAPi18n.__('drivers.address')}"
        width:100
        hidden: hiddenOnMobile()
        sortable: true
        search: where: 'client'  
      ,
        id: "mobile"
        field: "mobile"
        name: "#{TAPi18n.__('drivers.mobile')}"
        width:60
        sortable: true
        search: where: 'client'  
      ,
        id: "officePhone"
        field: "officePhone"
        name: "#{TAPi18n.__('drivers.officePhone')}"
        width:60
        hidden: hiddenOnMobile()
        sortable: true
        search: where: 'client'  
      ,
        id: "phone"
        field: "phone"
        name: "#{TAPi18n.__('drivers.phone')}"
        width:60
        hidden: hiddenOnMobile()
        sortable: true
        search: where: 'client'    
      ,
        id: "email"
        field: "email"
        name: "#{TAPi18n.__('drivers.email')}"
        width:80
        hidden: hiddenOnMobile()
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
      cursor: Drivers.find {},
        transform: (doc) -> _.extend doc,
          fullName: (if doc.firstName then doc.firstName+" " else "") + (if doc.name then doc.name else "")
          fullAddress: (if doc.city then doc.city+", " else "") +  (if doc.address then doc.address else "")

