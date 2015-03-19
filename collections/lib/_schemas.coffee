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

Schema.fleet = new SimpleSchema
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
  parent:
    type:String
    label: 'Group'
    autoform:
      firstOption: "(Select)"
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id

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

Schema.maintenanceTypes = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Name'
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

  description:
    type: String
    label: 'Description'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

  nextMaintenanceMonths:
    type: Number
    label: "Months"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

  nextMaintenanceKMs:
    type: Number
    decimal:true
    label: "Km"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

  nextMaintenanceEngineHours:
    type: Number
    decimal:true
    label: "Engine hours"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

Schema.maintenances = new SimpleSchema

  maintenanceType:
     type: String
     label: 'Type'
     autoform:
       firstOption: "(Select)"
       options: -> MaintenanceTypes.find().map (maintenanceType) -> label: maintenanceType.name, value: maintenanceType._id
       allowOptions: "true"
       template: "bootstrap3-horizontal"
       "label-class": "col-sm-4"
       "input-col-class": "col-sm-8"

  note:
    type: String
    decimal:true
    label: "Note"
    optional: true
    autoform:
      rows: 5

  vehicle:
     type:String
     label: "Vehicle"

  maintenanceDate:
    type:Date
    label: "Date"
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-4"
      "input-col-class": "col-sm-8"

  odometer:
    type: Number
    decimal:true
    label: "Odometer"
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-4"
      "input-col-class": "col-sm-8"

  engineHours:
    type: Number
    decimal:true
    label: "Engine hours"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-4"
      "input-col-class": "col-sm-8"

  nextMaintenanceDate:
    type:Date
    label: "Date"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-4"
      "input-col-class": "col-sm-8"

  nextMaintenanceOdometer:
    type: Number
    label: "Odometer"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-4"
      "input-col-class": "col-sm-8"

  nextMaintenanceEngineHours:
    type: Number
    decimal:true
    label: "Engine hours"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-4"
      "input-col-class": "col-sm-8"


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
      label: 'Driver'
      autoform:
        firstOption: "(Select)"
        options: -> Drivers.find().map (driver) ->
          label: driver.firstName+" "+driver.name
          value: driver._id
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   vehicle:
      type:String
      label: "Vehicle"
      autoform:
        firstOption: "(Изберете)"
        options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   date:
      type: Date
      label: "Date"
      optional: true
      autoform:
        type: "bootstrap-datepicker"
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-4"
        "input-col-class": "col-sm-8"
   time:
      type: String
      label: "Time"
      optional: true
      autoform:
        template: "bootstrap3-horizontal"
        "label-class": "col-sm-4"
        "input-col-class": "col-sm-8"

   event:
      type:String
      label:"Event"
      autoform:
        type: "select-radio-inline"
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
        options: () -> [
          {label: "associate", value: "begin"},
          {label: "disassociate", value: "end"}
        ]
