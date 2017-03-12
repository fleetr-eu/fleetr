Schema.vehicle = new SimpleSchema
  _id:
    type: String
    optional: true

  state:
    optional: true, type: String, label: ()->TAPi18n.__('vehicles.state')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  lastUpdate:
    type: Date, optional: true, label: "Last Update"

  restTime:
    type: Number, optional: true, label: "Rest time"

  tripTime:
    type: Number, optional: true, label: "Trip time"

  lat:
    type: Number, decimal: true, optional: true, label: "Latitude"

  lng:
    type: Number, decimal: true, optional: true, label: "Longitude"

  # DEPRECATED
  lon:
    type: Number, decimal: true, optional: true, label: "Longitude"

  loc:
    type: [Number], decimal: true, optional: true

  course:
    type: Number, optional: true

  courseCorrection:
    type: Number
    optional: true
    label: -> TAPi18n.__('vehicles.courseCorrection')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  speed:
    type: Number, decimal: true, optional: true, label: "Speed"
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  trip:
    type: Object
    optional: true
    blackbox: true

  rest:
    type: Object
    optional: true
    blackbox: true

  tags:
    type: String, optional: true, label: ()->TAPi18n.__('vehicles.tags')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  active:
    type: Boolean, optional: true, label: ()->TAPi18n.__('vehicles.active')
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  name:
    type: String, label: ()->TAPi18n.__('vehicles.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  licensePlate:
    type: String, label: ()->TAPi18n.__('vehicles.licensePlate')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  identificationNumber:
    type: String, label: ()->TAPi18n.__('vehicles.identificationNumber')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  engineNumber:
    type: String, label: ()->TAPi18n.__('vehicles.engineNumber')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  allocatedToFleet:
    type: String, label: ()->TAPi18n.__('vehicles.allocatedToFleet')
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  allocatedToFleetFromDate:
    type: Date, label:()->TAPi18n.__('vehicles.allocatedToFleetFromDate')
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  color:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.color')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  odometer:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.odometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  engineHours:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.engineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  unitId:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.unitId')
    custom: ->
      if @field("_id")?.value
        v = Vehicles.findOne({"unitId" : @value, "_id": {$ne: @field("_id").value}})
        "unitAlreadyExists" if v
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  phoneNumber:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.phoneNumber')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  nextTechnicalCheck:
    type: Date, label:()->TAPi18n.__('vehicles.nextTechnicalCheck')
    custom: ->
      "invalidFromToDates" if (@value and @value < (new Date()))
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  category:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.category')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  makeAndModel:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.makeAndModel')
    autoform:
      type: "typeahead"
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"
      # options: ->
      #   Vehicles.find({}, {fields: makeAndModel: 1}).map (v) ->
      #     label: v.makeAndModel
      #     value: v.makeAndModel

  kind:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.kind')
    autoform:
      firstOption: "(Изберете)"
      options: [
        { label:'Кола' , value: 'car'},
        { label:'Ван' , value: 'van'},
        { label:'Камион' , value: 'truck'},
        { label:'Автобус' , value: 'bus'}
      ]
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  maxPower:
    type: Number, optional: true,label:()->TAPi18n.__('vehicles.maxPower')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  fuelType:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.fuelType')
    allowedValues: ['Gas', 'Gasoline', 'Diesel', 'Electric', 'Hybrid']
    autoform:
      firstOption: "(Select)"
      options: [
        { label:'Gas' , value: 'Gas'},
        { label:'Gasoline' , value: 'Gasoline'},
        { label:'Diesel' , value: 'Diesel'},
        { label:'Electric' , value: 'Electric'},
        { label:'Hybrid' , value: 'Hybrid'}
      ]
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  productionYear:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.productionYear')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  body:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.body')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  engineDisplacement:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.engineDisplacement')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  maxFuelCapacity:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.maxFuelCapacity')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  maxSpeed:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.maxSpeed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  maxAllowedSpeed:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.maxAllowedSpeed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  mass:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.mass')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"

  "alarms.speedingAlarmActive":
    type: Boolean, label: "Speeding", optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-9", "input-col-class": "col-sm-3"

  "alarms.speedingAlarmSpeed":
    type: Number, label:"Speed", optional:true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-3", "input-col-class": "col-sm-9 input-group-sm"

  "alarms.idleAlarmActive":
    type: Boolean, label: "Idling", optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-9", "input-col-class": "col-sm-3 input-group-sm"

  "alarms.idleAlarmTime":
    type: Number, label: "Time", optional:true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-3", "input-col-class": "col-sm-9 input-group-sm"

  driver_id:
    type: String
    optional: true

  workHours:
    type: [Object]
    optional: true
    minCount: 7
    maxCount: 7

  "workHours.$.from":
    type: String, optional: true, label:()->TAPi18n.__('vehicles.workHoursFrom')
    autoform:
      afFieldInput:
        type: "time"
      template: "bootstrap3-horizontal", "label-class": "col-sm-2", "input-col-class": "col-sm-4 input-group-sm"

  "workHours.$.to":
    type: String, optional: true, label:()->TAPi18n.__('vehicles.workHoursTo')
    autoform:
      afFieldInput:
        type: "time"
      template: "bootstrap3-horizontal", "label-class": "col-sm-2", "input-col-class": "col-sm-4 input-group-sm"


Schema.odometers = new SimpleSchema
  _id:
    type: String, optional: true
  vehicleId:
    type: String, optional: true
  dateTime:
    type: Date, label:()->TAPi18n.__('vehicles.odometers.date')
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"
  value:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.odometers.value')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"
  oldValue:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.odometers.oldValue')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"
  correction:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.odometers.correction')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6 input-group-sm"
