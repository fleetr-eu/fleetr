remainingDaysFormater = (daysRed, daysOrange, decimal) -> (row, cell, value) ->
  if value
    console.log value
    attnIcon = ""
    if value < daysRed
      attnIcon = "<i class='fa fa-exclamation-triangle' style='color:red;' title='#{value}'></i>"
    else 
       if value < daysOrange 
        attnIcon = "<i class='fa fa-exclamation-triangle' style='color:orange;' title='#{value}'></i>"
    "<span>#{attnIcon}<div class='pull-right'>#{value}</div></span>"

aggregators= [
  new Slick.Data.Aggregators.Sum 'value'
]

Template.insurances.helpers
  options: ->
    i18nRoot: 'insurances'
    collection: Insurances
    editItemTemplate: 'insurance'
    additionalItemActionsTemaplate: 'paymentsButton'
    removeItemMethod: 'removeInsurance'
    gridConfig:
      columns: [
        id: "insuranceCompany"
        field: "insuranceCompany"
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
        width:80
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
        id: "value"
        field: "value"
        name: TAPi18n.__('insurances.value')
        width:80
        sortable: true
        align: 'right'
        search: where: 'client'
        groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
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
        formatter: remainingDaysFormater(2, 16) 
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Insurances.find {},
        transform: (doc) -> _.extend doc,
          insuranceTypeName: InsuranceTypes.findOne(_id: doc.insuranceType)?.name,
          remainingDays: moment(doc.policyValidTo).diff(moment(), 'days')
