@Schema = {};

Schema.fleetGroups = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Group name'
  description:
    type: String
    label: 'Description'
    optional: true

Schema.expenseGroups = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Name'
  description:
    type: String
    label: 'Description'
    optional: true

Schema.expenseTypes = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Name'
  description:
    type: String
    label: 'Description'
    optional: true

Schema.fleet = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Name'
  parent:
    type:String
    label: 'Group'
    autoform:
      firstOption: "(Select)"
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id

Schema.expenses = new SimpleSchema

  expenseType:
     type: String
     label: 'Expense Type'
     autoform:
       firstOption: "(Select)"
       options: -> ExpenseTypes.find().map (expenseType) -> label: expenseType.name, value: expenseType._id
       allowOptions: "true"
       template: "bootstrap3-horizontal"
       "label-class": "col-sm-5"
       "input-col-class": "col-sm-7"

   expenseGroup:
      type: String
      label: 'Expense Group'
      autoform:
        firstOption: "(Select)"
        options: -> ExpenseGroups.find().map (expenseGroup) -> label: expenseGroup.name, value: expenseGroup._id
        allowOptions: "true"
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

    vehicle:
       type:String
       label: "Vehicle"
       autoform:
         firstOption: "(Select)"
         options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
         allowOptions: "true"
         template: "bootstrap3-horizontal"
         "label-class": "col-sm-5"
         "input-col-class": "col-sm-7"

    odometer:
      type: Number
      decimal:true
      label: "Odometer"
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

   driver:
      type: String
      label: 'Driver'
      autoform:
        firstOption: "(Select)"
        options: -> Drivers.find().map (driver) -> label: driver.firstName+" "+driver.name, value: driver._id
        allowOptions: "true"
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

   invoiceNr:
      type:String
      label: "Invoce №"
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

   date:
      type:Date
      label: "Date"
      autoform:
        type: "bootstrap-datepicker"
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

   quantity:
      type: Number
      label: "Quantity"
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

   totalVATIncluded:
      type: Number
      decimal:true
      label: "Amount (VAT included)"
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

   vat:
     type: Number
     decimal:true
     label: "VAT"
     optional: true
     autoform:
       template: "bootstrap3-horizontal"
       "label-class": "col-sm-5"
       "input-col-class": "col-sm-7"


   VATIncluded:
      type: Boolean
      label: "VAT included"
      optional: true
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"
        "leftLabel": "true"

   discount:
      type: Number
      decimal:true
      label: "Discount"
      optional: true
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

   totalNet:
      type:Number
      label: "Amount (net)"
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-5"
        "input-col-class": "col-sm-7"

Schema.driverEvents = new SimpleSchema
  driver:
    type: String
    label: 'Шофьор'
    autoform:
      firstOption: "(Изберете)"
      options: -> Drivers.find().map (driver) ->
        label: driver.firstName+" "+driver.name
        value: driver._id
  eventType:
    type:String
    label: "Събитие"
    autoform:
      firstOption: "(Изберете)"
      options: -> EventTypes.find().map (event) -> label: event.name, value: event._id
  date:
    type:Date
    label: "Дата"
    autoform:
      type: "bootstrap-datepicker"
  description:
    type:String
    label: "Описание"

Schema.driverVehicleAssignments = new SimpleSchema
   _id:
      type: String
      optional: true
   driver:
      type: String
      label: 'Шофьор'
      autoform:
        firstOption: "(Изберете)"
        options: -> Drivers.find().map (driver) ->
          label: driver.firstName+" "+driver.name
          value: driver._id
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   vehicle:
      type:String
      label: "Автомобил"
      autoform:
        firstOption: "(Изберете)"
        options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   moment:
      type:Date
      label: "От"
      autoform:
        type: "datetimepicker"
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   event:
      type:String
      label:"Асоцииране"
      autoform:
        type: "select-radio-inline"
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
        options: () -> [
          {label: "асоцииране", value: "begin"},
          {label: "деасоцииране", value: "end"}
        ]
