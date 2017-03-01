Template.insuranceCompanies.helpers
  options: ->
    i18nRoot: 'insuranceCompanies'
    collection: InsuranceCompanies
    editItemTemplate: 'insuranceCompany'
    removeItemMethod: 'removeInsuranceCompany'
    gridConfig:
      columns: [
        id: "name"
        field: "name"
        name: TAPi18n.__('insuranceCompanies.name')
        width:50
        sortable: true
        search: where: 'client'
      ,
        id: "address"
        field: "address"
        name: TAPi18n.__('insuranceCompanies.address')
        width:50
        sortable: true
        search: where: 'client'
      ,
        id: "phone"
        field: "phone"
        name: TAPi18n.__('insuranceCompanies.phone')
        width:50
        sortable: true
        search: where: 'client'
      ,
        id: "email"
        field: "email"
        name: TAPi18n.__('insuranceCompanies.email')
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
      cursor: InsuranceCompanies.find {}
