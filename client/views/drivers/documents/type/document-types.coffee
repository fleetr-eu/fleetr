Template.documentTypes.helpers
  options: ->
    i18nRoot: 'documentTypes'
    collection: DocumentTypes
    editItemTemplate: 'documentType'
    removeItemMethod: 'removeDocumentType'
    gridConfig:
      cursor: DocumentTypes.find()
      columns: [
        id: "name"
        field: "name"
        name: "#{TAPi18n.__('documentTypes.name')}"
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "description"
        field: "description"
        name: "#{TAPi18n.__('documentTypes.description')}"
        width:150
        sortable: true
        search: where: 'client'
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
