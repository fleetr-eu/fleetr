Template.insuranceTypes.helpers
  options: ->
    i18nRoot: 'insuranceTypes'
    collection: InsuranceTypes
    editItemTemplate: 'insuranceType'
    removeItemMethod: 'removeInsuranceType'
    gridConfig:
      columns: [
        id: "insuranceTypes"
        field: "name"
        name: TAPi18n.__('insuranceTypes.name')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "description"
        field: "description"
        name: TAPi18n.__('insuranceTypes.description')
        width:120
        sortable: true
        search: where: 'client'
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: InsuranceTypes.find()
