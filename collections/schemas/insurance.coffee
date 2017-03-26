Schema.insuranceTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('insuranceTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('insuranceTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.insuranceCompanies = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('insuranceCompanies.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  address:
    type: String, optional: true, label: ()->TAPi18n.__('insuranceCompanies.address')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  phone:
    type: String, optional: true, label: ()->TAPi18n.__('insuranceCompanies.phone')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  email:
    type: String, optional: true, label: ()->TAPi18n.__('insuranceCompanies.email')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"


Schema.insurance = new SimpleSchema
  _id:
    type: String
    optional: true
  vehicle:
    type: String
    label: ()->TAPi18n.__('insurances.vehicle')
    autoform:
      firstOption: "(Изберете)"
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.name+" ("+vehicle.licensePlate+")", value: vehicle._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  insuranceCompany:
    type: String
    label: ()->TAPi18n.__('insurances.insuranceCompany')
    autoform:
      firstOption: "(Изберете)"
      options: -> InsuranceCompanies.find().map (insuranceCompany) -> label: insuranceCompany.name, value: insuranceCompany._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  insuranceType:
    type: String
    label: ()->TAPi18n.__('insurances.insuranceType')
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> InsuranceTypes.find().map (insurance) -> label: insurance.name, value: insurance._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  policyNo:
    type: String
    label: ()->TAPi18n.__('insurances.policyNo')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  value:
    type: Number
    decimal: true
    label: ()->TAPi18n.__('insurances.value')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  currency:
    type: String
    label: ()->TAPi18n.__('insurances.currency')
    optional: true

    allowedValues: ['Лев', 'Евро']
    autoform:
      firstOption: "(Изберете)"
      options: [
        { label:'Лева' , value: 'Лев'},
        { label:'Евро' , value: 'Евро'}
      ]
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  policyDate:
    type: String
    label: ()->TAPi18n.__('insurances.policyDate')
    optional: true
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  policyValidFrom:
    type: String
    label: ()->TAPi18n.__('insurances.policyValidFrom')
    custom: ->
      "invalidFromToDates" if (@value and @field('policyValidTo').value) and (@value > @field('policyValidTo').value)
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  policyValidTo:
    type: String
    label: ()->TAPi18n.__('insurances.policyValidTo')
    custom: ->
      "invalidFromToDates" if (@value and @field('policyValidFrom').value) and (@value < @field('policyValidFrom').value)
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  validityMonths:
    type: Number
    label: ()->TAPi18n.__('insurances.validityMonths')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  numberOfPayments:
    type: Number
    label: ()->TAPi18n.__('insurances.numberOfPayments')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  insuredFirstName:
    type: String
    optional: true
    label: ()->TAPi18n.__('insurances.insuredFirstName')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  insuredLastName:
    type: String
    optional: true
    label: ()->TAPi18n.__('insurances.insuredLastName')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  notes:
    type: String
    label: ()->TAPi18n.__('insurances.notes')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  tags:
    type: String
    label: ()->TAPi18n.__('insurances.tags')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.insurancePayment = new SimpleSchema
  _id:
    type: String
    optional: true
  insuranceId:
    type: String
    optional: true
  plannedDate:
    type: String
    label: ()->TAPi18n.__('insurancePayments.plannedDate')
    optional: true
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  actualDate:
    type: String
    label: ()->TAPi18n.__('insurancePayments.actualDate')
    optional: true
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  currency:
    type: String
    label: ()->TAPi18n.__('insurancePayments.currency')
    optional: true
    allowedValues: ['Лев', 'Евро']
    autoform:
      firstOption: "(Изберете)"
      options: [
        { label:'Лева' , value: 'Лев'},
        { label:'Евро' , value: 'Евро'}
      ]
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

  amountNoVAT:
    type: Number
    optional: true
    decimal: true
    label: ()->TAPi18n.__('insurancePayments.amountNoVAT')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  amountWithVAT:
    type: Number
    optional: true
    decimal: true
    label: ()->TAPi18n.__('insurancePayments.amountWithVAT')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  VONumber:
    type: String
    optional: true
    label: ()->TAPi18n.__('insurancePayments.VONumber')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  invoiceNo:
    type: String
    optional: true
    label: ()->TAPi18n.__('insurancePayments.invoiceNo')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
