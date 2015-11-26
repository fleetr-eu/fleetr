Template.insurancePayment.helpers
    insuranceId: -> @insuranceId
    
Template.insurancePayments.helpers
  insuranceId: -> @insuranceId

  options: ->
    i18nRoot: 'insurancePayments'
    collection: InsurancePayments
    editItemTemplate: 'insurancePayment'
    removeItemMethod: 'insurancePayment'
    gridConfig:
      columns: [
        id: "montlyPayment"
        field: "montlyPayment"
        name: TAPi18n.__('insurancePayments.montlyPayment')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "plannedDate"
        field: "plannedDate"
        name: TAPi18n.__('insurancePayments.plannedDate')
        width:80
        sortable: true
        search: where: 'client'
      ,  
        id: "actualDate"
        field: "actualDate"
        name: TAPi18n.__('insurancePayments.actualDate')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "currency"
        field: "currency"
        name: TAPi18n.__('insurancePayments.currency')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "amountNoVAT"
        field: "amountNoVAT"
        name: TAPi18n.__('insurancePayments.amountNoVAT')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "amountWithVAT"
        field: "amountWithVAT"
        name: TAPi18n.__('insurancePayments.amountWithVAT')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "VONumber"
        field: "VONumber"
        name: TAPi18n.__('insurancePayments.VONumber')
        width:80
        sortable: true
        search: where: 'client' 
      ,
        id: "VONumber"
        field: "VONumber"
        name: TAPi18n.__('insurancePayments.invoiceNo')
        width:80
        sortable: true
        search: where: 'client' 
      ,
        id: "VONumber"
        field: "VONumber"
        name: TAPi18n.__('insurancePayments.balance')
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
      cursor: InsurancePayments.find insuranceId:@insuranceId
