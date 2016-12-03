Schema.insuranceTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('insuranceTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('insuranceTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

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
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
     
  insuranceCompany:
    type: String
    label: ()->TAPi18n.__('insurances.insuranceCompany')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  insuranceType:
    type: String
    label: ()->TAPi18n.__('insurances.insuranceType')
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> InsuranceTypes.find().map (insurance) -> label: insurance.name, value: insurance._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  policyNo:
    type: String
    label: ()->TAPi18n.__('insurances.policyNo')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  value:
    type: Number
    label: ()->TAPi18n.__('insurances.value')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  currency:
    type: String
    label: ()->TAPi18n.__('insurances.currency')
    optional: true
    allowedValues: ['EUR', 'BGN']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  policyDate:
    type: Date
    label: ()->TAPi18n.__('insurances.policyDate')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  policyValidFrom:
    type: Date
    label: ()->TAPi18n.__('insurances.policyValidFrom')
    custom: ->
      "invalidFromToDates" if (@value and @field('policyValidTo').value) and (@value > @field('policyValidTo').value)
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  policyValidTo:
    type: Date
    label: ()->TAPi18n.__('insurances.policyValidTo')
    custom: ->
      "invalidFromToDates" if (@value and @field('policyValidFrom').value) and (@value < @field('policyValidFrom').value)
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  validityMonths:
    type: Number
    label: ()->TAPi18n.__('insurances.validityMonths')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  numberOfPayments:
    type: Number
    label: ()->TAPi18n.__('insurances.numberOfPayments')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  insuredFirstName:
    type: String
    optional: true
    label: ()->TAPi18n.__('insurances.insuredFirstName')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  insuredLastName:
    type: String
    optional: true
    label: ()->TAPi18n.__('insurances.insuredLastName')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  notes:
    type: String
    label: ()->TAPi18n.__('insurances.notes')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  tags:
    type: String
    label: ()->TAPi18n.__('insurances.tags')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

Schema.insurancePayment = new SimpleSchema
  _id:
    type: String
    optional: true
  insuranceId:
    type: String
    optional: true
  montlyPayment:
    type: Number
    label: ()->TAPi18n.__('insurancePayments.montlyPayment')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  plannedDate:
    type: Date
    label: ()->TAPi18n.__('insurancePayments.plannedDate')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"   
  actualDate:
    type: Date
    label: ()->TAPi18n.__('insurancePayments.actualDate')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  currency:
    type: String
    label: ()->TAPi18n.__('insurancePayments.currency')
    optional: true
    allowedValues: ['EUR', 'BGN']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8" 
  amountNoVAT:
    type: Number
    label: ()->TAPi18n.__('insurancePayments.amountNoVAT')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  amountWithVAT:
    type: Number
    label: ()->TAPi18n.__('insurancePayments.amountWithVAT')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  VONumber:
    type: String
    label: ()->TAPi18n.__('insurancePayments.VONumber')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"                 
  invoiceNo:
    type: String
    label: ()->TAPi18n.__('insurancePayments.invoiceNo')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  balance:
    type: Number
    label: ()->TAPi18n.__('insurancePayments.balance')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"     
   
  
