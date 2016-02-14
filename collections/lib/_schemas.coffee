@Schema = {};

Schema.alarms = new SimpleSchema
  _id:
    type: String, optional: true
  type:
    type: String, label: ()->TAPi18n.__('alarms.type')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  timestamp:
    type: Date, label: ()->TAPi18n.__('alarms.timestamp')
    autoform:
      type: "datetime-local"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  seen:
    type: Boolean, optional: true, label: ()->TAPi18n.__('alarms.seen')
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  data:
    type: Object, optional: true, label: ->TAPi18n.__('alarms.data')
  description:
    type: String, label: ->TAPi18n.__('alarms.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"


Schema.customEvents = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('customEvents.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  fleetGroupId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.fleetGroup')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id
  fleetId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.fleet')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
  vehicleId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.vehicle')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.name, value: vehicle._id
  driverId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.driver')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Drivers.find().map (driver) -> label: driver.name, value: driver._id
  description:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  date:
    type: Date, optional: true, label: ()->TAPi18n.__('customEvents.date')
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  odometer:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('customEvents.odometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  engineHours:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('customEvents.engineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  speed:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('customEvents.speed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  seen:
    type: Boolean
    label: ()->TAPi18n.__('customEvents.seen')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  active:
    type: Boolean
    label: "Активен"
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

Schema.geofenceEvents = new SimpleSchema
  _id:
    type: String, optional: true
  fleetGroupId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.fleetGroup')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id
  fleetId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.fleet')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
  vehicleId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.vehicle')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.name, value: vehicle._id
  driverId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.driver')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Drivers.find().map (driver) -> label: driver.name, value: driver._id
  geofenceId:
    type: String, label: ()->TAPi18n.__('geofenceEvents.geofence')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Geofences.find().map (geofence) -> label: geofence.name, value: geofence._id
  description:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  enter:
    type: Boolean
    label: ()->TAPi18n.__('geofenceEvents.enter')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  exit:
    type: Boolean
    label: ()->TAPi18n.__('geofenceEvents.exit')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  stay:
    type: Boolean
    label: ()->TAPi18n.__('geofenceEvents.stay')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-4"
  minutes:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('geofenceEvents.minutes')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-2", "input-col-class": "col-sm-2"
  seen:
    type: Boolean
    label: ()->TAPi18n.__('geofenceEvents.seen')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  active:
    type: Boolean
    label: "Активен"
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

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

Schema.documents = new SimpleSchema
  _id:
    type: String, optional: true
  driverId:
    type: String, optional: true
  type:
    type: String
    label: ()->TAPi18n.__('documents.type')
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> DocumentTypes.find().map (documentType) -> label: documentType.name, value: documentType._id
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  number:
    type: String, label: ()->TAPi18n.__('documents.number')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  validFrom:
    type: Date, label: ()->TAPi18n.__('documents.validFrom')
    custom: ->
      "invalidFromToDates" if (@value and @field('validTo').value) and (@value > @field('validTo').value)
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  validTo:
    type: Date, label: ()->TAPi18n.__('documents.validTo')
    custom: -> 
        "invalidFromToDates" if (@value and @field('validFrom').value) and (@value < @field('validFrom').value)
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  issuedBy:
    type: String, label: ()->TAPi18n.__('documents.issuedBy')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

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
  fines:
    type: Boolean, label: ()->TAPi18n.__('expenseGroups.fines')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal", leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

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
         optional: true
         allowOptions: "true"
         template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   location:
       type:String
       label: ()->TAPi18n.__('expenses.location')
       optional: true
       autoform:
         template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   odometer:
      type: Number
      decimal:true
      label: ()->TAPi18n.__('expenses.odometer')
      optional: true
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   driver:
      type: String
      label: ()->TAPi18n.__('expenses.driver')
      optional: true
      autoform:
        firstOption: ()->TAPi18n.__('dropdown.select')
        options: -> Drivers.find().map (driver) -> label: driver.firstName+" "+driver.name, value: driver._id
        allowOptions: "true"
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   invoiceNr:
      type:String
      label: ()->TAPi18n.__('expenses.invoiceNr')
      optional: true
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
      decimal:true
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
      decimal:true
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
      decimal:true
      label: ()->TAPi18n.__('expenses.total')
      autoform:
        template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
   description:
     type: String, optional: true, label: ()->TAPi18n.__('expenses.description')
     autoform:
       template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"

Schema.maintenanceTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()-> TAPi18n.__('maintenanceTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  technicalCheck:
    type: Boolean, label: ()->TAPi18n.__('maintenanceTypes.technicalCheck')
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal", leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  description:
    type: String, optional: true, label: ()-> TAPi18n.__('maintenanceTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
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
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  maintenanceDate:
    type:Date, label: ()-> TAPi18n.__('maintenances.maintenanceDate')
    custom: ->
      "invalidFromToDates" if (@value and @field('nextMaintenanceDate').value) and (@value > @field('nextMaintenanceDate').value)
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  odometer:
    type: Number, decimal:true, label: ()-> TAPi18n.__('maintenances.odometer')
    custom: ->
      "invalidFromToKM" if (@value and @field('nextMaintenanceOdometer').value) and (@value > @field('nextMaintenanceOdometer').value)
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  engineHours:
    type: Number, decimal:true, optional: true
    label: ()-> TAPi18n.__('maintenances.engineHours')
    custom: ->
      "invalidFromToHours" if (@value and @field('nextMaintenanceEngineHours').value) and (@value > @field('nextMaintenanceEngineHours').value)
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceDate:
    type:Date, optional: true, label: ()-> TAPi18n.__('maintenances.nextMaintenanceDate')
    custom: ->
      "invalidFromToDates" if (@value and @field('maintenanceDate').value) and (@value < @field('maintenanceDate').value)
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceOdometer:
    type: Number
    optional: true
    custom: ->
      "invalidFromToKM" if (@value and @field('odometer').value) and (@value < @field('odometer').value)
    label: ()-> TAPi18n.__('maintenances.nextMaintenanceOdometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8"
  nextMaintenanceEngineHours:
    type: Number, decimal:true, optional: true
    label: ()-> TAPi18n.__('maintenances.nextMaintenanceEngineHours')
    custom: ->
      "invalidFromToHours" if (@value and @field('engineHours').value) and (@value < @field('engineHours').value)
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
