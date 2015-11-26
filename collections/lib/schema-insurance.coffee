Schema.insurance = new SimpleSchema
  _id:
    type: String
    optional: true
  vehicle:
    type: String
    label: ()->TAPi18n.__('insurances.vehicle')
    autoform:
      firstOption: "(Изберете)"
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"   
  insuranceCompany:
    type: String
    label: ()->TAPi18n.__('insurances.insuranceCompany')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7" 
  insuranceType:
    type: String
    label: ()->TAPi18n.__('insurances.insuranceType')
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> InsuranceTypes.find().map (insurance) -> label: insurance.name, value: insurance._id
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"  
  policyNo:
    type: String
    label: ()->TAPi18n.__('insurances.policyNo')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7" 
  value:
    type: Number
    label: ()->TAPi18n.__('insurances.value')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"      
  currency:
    type: String
    label: ()->TAPi18n.__('insurances.currency')
    optional: true
    allowedValues: ['EUR', 'BGN']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"        
  policyDate:
    type: Date
    label: ()->TAPi18n.__('insurances.policyDate')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"      
  policyValidFrom:
    type: Date
    label: ()->TAPi18n.__('insurances.policyValidFrom')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7" 
  policyValidTo:
    type: Date
    label: ()->TAPi18n.__('insurances.policyValidTo')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  validityMonths:
    type: Number
    label: ()->TAPi18n.__('insurances.validityMonths')
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"      
  numberOfPayments:
    type: Number
    label: ()->TAPi18n.__('insurances.numberOfPayments')
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"  
  insuredFirstName:
    type: String
    label: ()->TAPi18n.__('insurances.insuredFirstName')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7" 
  insuredLastName:
    type: String
    label: ()->TAPi18n.__('insurances.insuredLastName')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  notes:
    type: String
    label: ()->TAPi18n.__('insurances.notes')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"            
  tags:
    type: String
    label: ()->TAPi18n.__('insurances.tags')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

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
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  plannedDate:
    type: Date
    label: ()->TAPi18n.__('insurancePayments.plannedDate')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"   
  actualDate:
    type: Date
    label: ()->TAPi18n.__('insurancePayments.actualDate')
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  currency:
    type: String
    label: ()->TAPi18n.__('insurancePayments.currency')
    optional: true
    allowedValues: ['EUR', 'BGN']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7" 
  amountNoVAT:
    type: Number
    label: ()->TAPi18n.__('insurancePayments.amountNoVAT')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  amountWithVAT:
    type: Number
    label: ()->TAPi18n.__('insurancePayments.amountWithVAT')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  VONumber:
    type: String
    label: ()->TAPi18n.__('insurancePayments.VONumber')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"                  
  invoiceNo:
    type: String
    label: ()->TAPi18n.__('insurancePayments.invoiceNo')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  balance:
    type: Number
    label: ()->TAPi18n.__('insurancePayments.balance')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"      
   
  
