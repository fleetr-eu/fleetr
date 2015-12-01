@Schema = {};

Schema.fleetGroups = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('fleetGroups.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('fleetGroups.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

Schema.fleet = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('fleet.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('fleet.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      rows: 5
  parent:
    type:String, label: ()->TAPi18n.__('fleet.parent')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id

Schema.documentTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('documentTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('documentTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      rows: 5

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
      rows: 5

Schema.expenseGroups = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('expenseGroups.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('expenseGroups.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      rows: 5

Schema.expenseTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('expenseTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  unitOfMeasure:
    type: String, label: ()->TAPi18n.__('expenseTypes.unitOfMeasure')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('expenseTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      rows: 5

Schema.expenses = new SimpleSchema
  _id:
    type: String, optional: true
  expenseType:
     type: String,  label: ()->TAPi18n.__('expenses.expenseType')
     autoform:
       firstOption: ()->TAPi18n.__('dropdown.select')
       options: -> ExpenseTypes.find().map (expenseType) -> label: expenseType.name, value: expenseType._id
       allowOptions: "true"
       template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   expenseGroup:
      type: String
      label: ()->TAPi18n.__('expenses.expenseGroup')
      autoform:
        firstOption: ()->TAPi18n.__('dropdown.select')
        options: -> ExpenseGroups.find().map (expenseGroup) -> label: expenseGroup.name, value: expenseGroup._id
        allowOptions: "true"
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   vehicle:
       type:String
       label: ()->TAPi18n.__('expenses.vehicle')
       autoform:
         firstOption: ()->TAPi18n.__('dropdown.select')
         options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
         allowOptions: "true"
         template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   location:
       type:String
       label: ()->TAPi18n.__('expenses.location')
       autoform:
         template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   odometer:
      type: Number
      decimal:true
      label: ()->TAPi18n.__('expenses.odometer')
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   driver:
      type: String
      label: ()->TAPi18n.__('expenses.driver')
      autoform:
        firstOption: ()->TAPi18n.__('dropdown.select')
        options: -> Drivers.find().map (driver) -> label: driver.firstName+" "+driver.name, value: driver._id
        allowOptions: "true"
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   invoiceNr:
      type:String
      label: ()->TAPi18n.__('expenses.invoiceNr')
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   date:
      type:Date
      label: ()->TAPi18n.__('expenses.date')
      autoform:
        type: "bootstrap-datepicker"
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   quantity:
      type: Number
      label: ()->TAPi18n.__('expenses.quantity')
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   totalVATIncluded:
      type: Number
      decimal:true
      label: ()->TAPi18n.__('expenses.totalVATIncluded')
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   vat:
     type: Number
     decimal:true
     label: ()->TAPi18n.__('expenses.vat')
     optional: true
     autoform:
       template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   VATIncluded:
      type: Boolean
      label: ()->TAPi18n.__('expenses.VATIncluded')
      optional: true
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8", "leftLabel": "true"
   discount:
      type: Number
      decimal:true
      label: ()->TAPi18n.__('expenses.discount')
      optional: true
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   total:
      type:Number
      label: ()->TAPi18n.__('expenses.total')
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   description:
     type: String, optional: true, label: ()->TAPi18n.__('expenses.description')
     autoform:
       template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
       rows: 5

Schema.maintenanceTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()-> TAPi18n.__('maintenanceTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()-> TAPi18n.__('maintenanceTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      rows:5
  nextMaintenanceMonths:
    type: Number, optional: true, label: ()-> TAPi18n.__('maintenanceTypes.nextMaintenanceMonths')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceKMs:
    type: Number, decimal:true, optional: true, label: ()-> TAPi18n.__('maintenanceTypes.nextMaintenanceKMs')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceEngineHours:
    type: Number, optional: true, decimal:true, label: ()-> TAPi18n.__('maintenanceTypes.nextMaintenanceEngineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

Schema.maintenances = new SimpleSchema
  _id:
    type: String, optional: true
  vehicle:
   type:String, label: ()-> TAPi18n.__('maintenances.vehicle')
  maintenanceType:
     type: String
     label: ()-> TAPi18n.__('maintenances.maintenanceType')
     autoform:
       firstOption: "(Select)"
       options: -> MaintenanceTypes.find().map (maintenanceType) -> label: maintenanceType.name, value: maintenanceType._id
       allowOptions: "true"
       template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, decimal:true, optional: true, label: ()-> TAPi18n.__('maintenances.description')
    autoform:
      rows: 5
  maintenanceDate:
    type:Date, label: ()-> TAPi18n.__('maintenances.maintenanceDate')
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  odometer:
    type: Number, decimal:true, label: ()-> TAPi18n.__('maintenances.odometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  engineHours:
    type: Number, decimal:true, optional: true
    label: ()-> TAPi18n.__('maintenances.engineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceDate:
    type:Date, optional: true, label: ()-> TAPi18n.__('maintenances.nextMaintenanceDate')
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceOdometer:
    type: Number
    optional: true
    label: ()-> TAPi18n.__('maintenances.nextMaintenanceOdometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceEngineHours:
    type: Number, decimal:true, optional: true
    label: ()-> TAPi18n.__('maintenances.nextMaintenanceEngineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

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
