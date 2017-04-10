aggregators= [
  new Slick.Data.Aggregators.Sum 'value'
]

Template.insurances.helpers
  options: ->
    i18nRoot: 'insurances'
    collection: Insurances
    editItemTemplate: 'insurance'
    additionalItemActionsTemplate: 'paymentsButton'
    removeItemMethod: 'removeInsurance'
    gridConfig:
      columns: [
        id: "vehicle"
        field: "vehicle"
        name: TAPi18n.__('insurances.vehicle')
        width:90
        sortable: true
        search: where: 'client'
        groupable:
          hideColumn: true
          aggregators: aggregators
      ,
        id: "insuranceCompanyName"
        field: "insuranceCompanyName"
        name: TAPi18n.__('insurances.insuranceCompany')
        width:80
        sortable: true
        search: where: 'client'
        groupable:
          aggregators: aggregators
      ,
        id: "insuranceType"
        field: "insuranceTypeName"
        name: TAPi18n.__('insurances.insuranceType')
        width:40
        sortable: true
        search: where: 'client'
        groupable:
          aggregators: aggregators
      ,
        id: "policyNo"
        field: "policyNo"
        name: TAPi18n.__('insurances.policyNo')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "policyDate"
        field: "policyDate"
        name: TAPi18n.__('insurances.policyDate')
        formatter: FleetrGrid.Formatters.dateFormatter
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "policyValidFrom"
        field: "policyValidFrom"
        name: TAPi18n.__('insurances.policyValidFrom')
        formatter: FleetrGrid.Formatters.dateFormatter
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "policyValidTo"
        field: "policyValidTo"
        name: TAPi18n.__('insurances.policyValidTo')
        formatter: FleetrGrid.Formatters.dateFormatter
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "remainingDays"
        field: "remainingDays"
        name: TAPi18n.__('insurances.remainingDays')
        width:40
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.decoratedLessThanFormatter(2, 16)
      ,
        id: "value"
        field: "value"
        name: TAPi18n.__('insurances.value')
        width:50
        sortable: true
        align: 'right'
        search: where: 'client'
        formatter: FleetrGrid.Formatters.moneyFormatter
        groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
      ,
        id: "balance"
        field: "balance"
        name: TAPi18n.__('insurances.balance')
        width:50
        sortable: true
        align: 'right'
        search: where: 'client'
        formatter: FleetrGrid.Formatters.moneyFormatter
        groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Insurances.find {},
        transform: (doc) ->
          payments = InsurancePayments.find(insuranceId: doc._id).fetch()
          addAll = (sum, payment)-> sum + payment.amountWithVAT
          paid = _.reduce(payments, addAll, 0)
          _.extend doc,
          vehicle: Vehicles.findOne(_id: doc.vehicle).displayName()
          insuranceTypeName: InsuranceTypes.findOne(_id: doc.insuranceType)?.name,
          insuranceCompanyName: InsuranceCompanies.findOne(_id: doc.insuranceCompany)?.name,
          remainingDays: if doc.policyValidTo then moment(doc.policyValidTo).diff(moment(), 'days') else -1
          balance: doc.value - paid
      customize: (grid) ->
        grid.addGroupBy 'vehicle', TAPi18n.__('insurances.vehicle'), aggregators, null, true
