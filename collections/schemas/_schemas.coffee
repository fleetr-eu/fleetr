@Schema = {}

Schema.alarms = new SimpleSchema
  _id:
    type: String, optional: true
  type:
    type: String, label: ()->TAPi18n.__('alarms.type')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  timestamp:
    type: String, label: ()->TAPi18n.__('alarms.timestamp')
    autoform:
      type: "datetime-local"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  data:
    type: Object, optional: true, label: ->TAPi18n.__('alarms.data')
  description:
    type: String, label: ->TAPi18n.__('alarms.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.configurationSettings = new SimpleSchema
  _id:
    type: String, optional: true
  category:
    type: String, label: ()->TAPi18n.__('configurationSettings.category')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  type:
    type: String, label: ()->TAPi18n.__('configurationSettings.type')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: "(Изберете)"
      options: ->
        [
          { label: "Текст", value: 0 },
          { label: "Число", value: 1 },
          { label: "Дата", value: 2 },
          { label: "JSON", value: 3 }
        ]
  name:
    type: String, label: ()->TAPi18n.__('configurationSettings.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  value:
    type: String, label: ()->TAPi18n.__('configurationSettings.value')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"


Schema.customEvents = new SimpleSchema
  _id:
    type: String, optional: true
  sourceId:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('customEvents.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  kind:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.kind')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4"
      options: () -> [
          { label: "Технически преглед", value: "Технически преглед"}
          { label: "Поддръжка", value: "Поддръжка"}
          { label: "Документ", value: "Документ"}
          { label: "Застраховка", value: "Застраховка"}
          { label: "Друго", value: "Друго"}
        ]
  fleetGroupId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.fleetGroup')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id
  fleetId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.fleet')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
  vehicleId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.vehicle')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.name+" ("+vehicle.licensePlate+")", value: vehicle._id
  driverId:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.driver')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Drivers.find().map (driver) -> label: driver.name, value: driver._id
  description:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  date:
    type: String, optional: true, label: ()->TAPi18n.__('customEvents.date')
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  odometer:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('customEvents.odometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  engineHours:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('customEvents.engineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  speed:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('customEvents.speed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.geofenceEvents = new SimpleSchema
  _id:
    type: String, optional: true
  fleetGroupId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.fleetGroup')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id
  fleetId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.fleet')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
  vehicleId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.vehicle')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.name+" ("+vehicle.licensePlate+")", value: vehicle._id
  driverId:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.driver')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Drivers.find().map (driver) -> label: driver.name, value: driver._id
  geofenceId:
    type: String, label: ()->TAPi18n.__('geofenceEvents.geofence')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Geofences.find().map (geofence) -> label: geofence.name, value: geofence._id
  description:
    type: String, optional: true, label: ()->TAPi18n.__('geofenceEvents.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-4 input-group-sm"
  minutes:
    optional: true
    type: Number
      decimal:true
    label: ()->TAPi18n.__('geofenceEvents.minutes')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-2", "input-col-class": "col-sm-2 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.fleetGroups = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('fleetGroups.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('fleetGroups.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.fleet = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('fleet.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('fleet.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  parent:
    type:String, label: ()->TAPi18n.__('fleet.parent')
    autoform:
      type: 'select2'
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id

Schema.documentTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()->TAPi18n.__('documentTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()->TAPi18n.__('documentTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.documents = new SimpleSchema
  _id:
    type: String, optional: true
  driverId:
    type: String, optional: true
  type:
    type: String
    label: ()->TAPi18n.__('documents.type')
    autoform:
      type: 'select2'
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> DocumentTypes.find().map (documentType) -> label: documentType.name, value: documentType._id
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  number:
    type: String, label: ()->TAPi18n.__('documents.number')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  validFrom:
    type: String, label: ()->TAPi18n.__('documents.validFrom')
    custom: ->
      "invalidFromToDates" if (@value and @field('validTo').value) and (@value > @field('validTo').value)
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  validTo:
    type: String, label: ()->TAPi18n.__('documents.validTo')
    custom: ->
      "invalidFromToDates" if (@value and @field('validFrom').value) and (@value < @field('validFrom').value)
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  issuedBy:
    type: String, label: ()->TAPi18n.__('documents.issuedBy')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.maintenanceTypes = new SimpleSchema
  _id:
    type: String, optional: true
  name:
    type: String, label: ()-> TAPi18n.__('maintenanceTypes.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
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
      template: "bootstrap3-horizontal", leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, optional: true, label: ()-> TAPi18n.__('maintenanceTypes.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  nextMaintenanceMonths:
    type: Number, optional: true, label: ()-> TAPi18n.__('maintenanceTypes.nextMaintenanceMonths')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  nextMaintenanceKMs:
    type: Number, decimal:true, optional: true, label: ()-> TAPi18n.__('maintenanceTypes.nextMaintenanceKMs')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  nextMaintenanceEngineHours:
    type: Number, optional: true, decimal:true, label: ()-> TAPi18n.__('maintenanceTypes.nextMaintenanceEngineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.maintenances = new SimpleSchema
  _id:
    type: String, optional: true
  vehicle:
    type:String, label: ()-> TAPi18n.__('maintenances.vehicle')
  maintenanceType:
    type: String
    label: ()-> TAPi18n.__('maintenances.maintenanceType')
    autoform:
      type: 'select2'
      firstOption: "(Изберете)"
      options: -> MaintenanceTypes.find().map (maintenanceType) -> label: maintenanceType.name, value: maintenanceType._id
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  description:
    type: String, decimal:true, optional: true, label: ()-> TAPi18n.__('maintenances.description')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  maintenanceDate:
    type:String, label: ()-> TAPi18n.__('maintenances.maintenanceDate')
    custom: ->
      "invalidFromToDates" if (@value and @field('nextMaintenanceDate').value) and (@value > @field('nextMaintenanceDate').value)
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  odometer:
    type: Number, decimal:true, label: ()-> TAPi18n.__('maintenances.odometer')
    custom: ->
      "invalidFromToKM" if (@value and @field('nextMaintenanceOdometer').value) and (@value > @field('nextMaintenanceOdometer').value)
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  engineHours:
    type: Number, decimal:true, optional: true
    label: ()-> TAPi18n.__('maintenances.engineHours')
    custom: ->
      "invalidFromToHours" if (@value and @field('nextMaintenanceEngineHours').value) and (@value > @field('nextMaintenanceEngineHours').value)
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  nextMaintenanceDate:
    type:String, optional: true, label: ()-> TAPi18n.__('maintenances.nextMaintenanceDate')
    custom: ->
      "invalidFromToDates" if (@value and @field('maintenanceDate').value) and (@value < @field('maintenanceDate').value)
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  nextMaintenanceOdometer:
    type: Number
    optional: true
    custom: ->
      "invalidFromToKM" if (@value and @field('odometer').value) and (@value < @field('odometer').value)
    label: ()-> TAPi18n.__('maintenances.nextMaintenanceOdometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  nextMaintenanceEngineHours:
    type: Number, decimal:true, optional: true
    label: ()-> TAPi18n.__('maintenances.nextMaintenanceEngineHours')
    custom: ->
      "invalidFromToHours" if (@value and @field('engineHours').value) and (@value < @field('engineHours').value)
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  performed:
    type: Boolean
    label: ()->TAPi18n.__('maintenances.performed')
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
      leftLabel:"true", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"

Schema.driverEvents = new SimpleSchema
  driver:
    type: String
    label: 'Шофьор'
    autoform:
      type: 'select2'
      firstOption: "(Изберете)"
      options: -> Drivers.find().map (driver) ->
        label: driver.firstName+" "+driver.name
        value: driver._id
  eventType:
    type:String
    label: "Събитие"
    autoform:
      type: 'select2'
      firstOption: "(Изберете)"
      options: -> EventTypes.find().map (event) -> label: event.name, value: event._id
  date:
    type:String
    label: "Дата"
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
  description:
    type:String
    label: "Описание"

Schema.driverVehicleAssignments = new SimpleSchema
  _id:
    type: String
    optional: true
  driver:
    type: String
    label: ()->TAPi18n.__('driverVehicleAssignments.driverName')
    autoform:
      type: 'select2'
      firstOption: "(Изберете)"
      options: -> Drivers.find().map (driver) ->
        label: driver.fullName()
        value: driver._id
      template: "bootstrap3-horizontal", "label-class":"col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  vehicle:
    type:String
    label: ()->TAPi18n.__('driverVehicleAssignments.vehicleName')
    autoform:
      type: 'select2'
      firstOption: "(Изберете)"
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.name+" ("+vehicle.licensePlate+")", value: vehicle._id
      template: "bootstrap3-horizontal", "label-class":"col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  date:
    type: String
    defaultValue: moment().format('DD.MM.YYYY')
    label: ()->TAPi18n.__('driverVehicleAssignments.date')
    optional: true
    autoform:
      type: "datetimepicker"
      opts: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  time:
    type: String
    defaultValue: moment().format('HH:mm')
    label: ()->TAPi18n.__('driverVehicleAssignments.time')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
  event:
    type:String
    label: ()->TAPi18n.__('driverVehicleAssignments.event')
    autoform:
      type: "select-radio-inline"
      template: "bootstrap3-horizontal", "label-class":"col-sm-4", "input-col-class": "col-sm-8 input-group-sm"
      options: () -> [
        { label: TAPi18n.__('driverVehicleAssignments.associate'), value: "begin"},
        { label: TAPi18n.__('driverVehicleAssignments.disassociate'), value: "end"}
      ]
