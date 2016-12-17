Schema.expenses = new SimpleSchema
  _id:
    type: String, optional: true
  expenseType:
    type: String
    label: () -> TAPi18n.__('expenses.expenseType')
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> ExpenseTypes.find().map (expenseType) -> label: expenseType.name, value: expenseType._id
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  expenseGroup:
    type: String
    label: ()->TAPi18n.__('expenses.expenseGroup')
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> ExpenseGroups.find().map (expenseGroup) -> label: expenseGroup.name, value: expenseGroup._id
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  vehicle:
    type: String
    label: ()->TAPi18n.__('expenses.vehicle')
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.name+" ("+vehicle.licensePlate+")", value: vehicle._id
      optional: true
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  location:
    type:String
    label: ()->TAPi18n.__('expenses.location')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  odometer:
    type: Number
    decimal:true
    label: ()->TAPi18n.__('expenses.odometer')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  driver:
    type: String
    label: ()->TAPi18n.__('expenses.driver')
    optional: true
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Drivers.find().map (driver) -> label: driver.firstName+" "+driver.name, value: driver._id
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  invoiceNr:
    type: String
    label: ()->TAPi18n.__('expenses.invoiceNr')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  date:
    type: Date
    label: ()->TAPi18n.__('expenses.date')
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  quantity:
    type: Number
    decimal:true
    label: ()->TAPi18n.__('expenses.quantity')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  totalVATIncluded:
    type: Number
    decimal:true
    label: ()->TAPi18n.__('expenses.totalVATIncluded')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  vat:
    type: Number
    decimal:true
    label: ()->TAPi18n.__('expenses.vat')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  VATIncluded:
    type: Boolean
    decimal: true
    label: ()->TAPi18n.__('expenses.VATIncluded')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm", "leftLabel": "true"
  discount:
    type: Number
    decimal:true
    label: ()->TAPi18n.__('expenses.discount')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  total:
    type:Number
    decimal:true
    label: ()->TAPi18n.__('expenses.total')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('expenses.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.expenseGroups = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('expenseGroups.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('expenseGroups.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.expenseTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('expenseTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  unitOfMeasure:
    type: String, label: ()->TAPi18n.__('expenseTypes.unitOfMeasure')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  fuels:
    type: Boolean, label: ()->TAPi18n.__('expenseTypes.fuels')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal", leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  fines:
    type: Boolean, label: ()->TAPi18n.__('expenseTypes.fines')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal", leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('expenseTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
