Template.documents.onRendered ->
  Template.document.helpers
    driverId: => @data.driverId

Template.documents.helpers
  options: ->
    i18nRoot: 'documents'
    collection: Documents
    editItemTemplate: 'document'
    removeItemMethod: 'removeDocument'
    gridConfig:
      columns: [
        id: "type"
        field: "documentTypeName"
        name: "#{TAPi18n.__('documentTypes.name')}"
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "number"
        field: "number"
        name: "#{TAPi18n.__('documents.number')}"
        width:50
        sortable: true
        search: where: 'client'
      ,
        id: "validFrom"
        field: "validFrom"
        name: "#{TAPi18n.__('documents.validFrom')}"
        width:50
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "validTo"
        field: "validTo"
        name: "#{TAPi18n.__('documents.validTo')}"
        width:50
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "issuedBy"
        field: "issuedBy"
        name: "#{TAPi18n.__('documents.issuedBy')}"
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
      cursor: Documents.find driverId:@driverId,
        transform: (doc) -> _.extend doc,
          documentTypeName: DocumentTypes.findOne(_id: doc.type)?.name