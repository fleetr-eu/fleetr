Template.insurances.helpers
  options: ->
    i18nRoot: 'insurances'
    collection: Insurances
    editItemTemplate: 'insurance'
    removeItemMethod: 'removeInsurance'
    gridConfig:
      columns: [
        id: "insuranceCompany"
        field: "insuranceCompany"
        name: TAPi18n.__('insurances.insuranceCompany')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "insuranceType"
        field: "insuranceType"
        name: TAPi18n.__('insurances.insuranceType')
        width:80
        sortable: true
        search: where: 'client'
      ,  
        id: "policyNo"
        field: "policyNo"
        name: TAPi18n.__('insurances.policyNo')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "value"
        field: "value"
        name: TAPi18n.__('insurances.value')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "policyDate"
        field: "policyDate"
        name: TAPi18n.__('insurances.policyDate')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "policyValidFrom"
        field: "policyValidFrom"
        name: TAPi18n.__('insurances.policyValidFrom')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "policyValidTo"
        field: "policyValidTo"
        name: TAPi18n.__('insurances.policyValidTo')
        width:80
        sortable: true
        search: where: 'client'  
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Insurances.find()
