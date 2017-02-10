Template.insurancePayments.onRendered ->
  Template.insurancePayment.helpers
    insuranceId: => @data.insuranceId


Template.insurancePayments.helpers
  title: ->
    insurance: ins = Insurances.findOne(_id: @insuranceId)
    vehicleName: Vehicles.findOne(_id: ins.vehicle).displayName()
  options: ->
    i18nRoot: 'insurancePayments'
    collection: InsurancePayments
    editItemTemplate: 'insurancePayment'
    removeItemMethod: 'insurancePayment'
    gridConfig:
      columns: [
        id: "plannedDate"
        field: "plannedDate"
        name: TAPi18n.__('insurancePayments.plannedDate')
        hidden: false
        width:80
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "actualDate"
        field: "actualDate"
        name: TAPi18n.__('insurancePayments.actualDate')
        width:80
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
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
        hidden: false
        width:80
        sortable: true
        formatter: FleetrGrid.Formatters.moneyFormatter
        search: where: 'client'
      ,
        id: "amountWithVAT"
        field: "amountWithVAT"
        name: TAPi18n.__('insurancePayments.amountWithVAT')
        width:80
        sortable: true
        formatter: FleetrGrid.Formatters.moneyFormatter
        search: where: 'client'
      ,
        id: "VONumber"
        field: "VONumber"
        name: TAPi18n.__('insurancePayments.VONumber')
        hidden: false
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "invoiceNo"
        field: "invoiceNo"
        name: TAPi18n.__('insurancePayments.invoiceNo')
        hidden: false
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
