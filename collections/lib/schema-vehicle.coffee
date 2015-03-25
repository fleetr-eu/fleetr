Schema.vehicle = new SimpleSchema
  _id:
    type: String
    optional: true

  state:
    optional: true, type: String, label: ()->TAPi18n.__('vehicle.state')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  lastUpdate:
    type: Date, optional: true, label: "Last Update"

  lat:
    type: Number, decimal: true, optional: true, label: "Lat"

  lon:
    type: Number, decimal: true, optional: true, label: "Lon"

  speed:
    type: Number, decimal: true, optional: true, label: "Speed"
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  tags:
    type: String, optional: true, label: ()->TAPi18n.__('vehicle.tags')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  active:
    type: Boolean, optional: true, label: ()->TAPi18n.__('vehicle.active')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6", "leftLabel": "true"

  name:
    type: String, label: ()->TAPi18n.__('vehicle.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  licensePlate:
    type: String, label: ()->TAPi18n.__('vehicle.licensePlate')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  identificationNumber:
    type: String, label: ()->TAPi18n.__('vehicle.identificationNumber')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  engineNumber:
    type: String, label: ()->TAPi18n.__('vehicle.engineNumber')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  allocatedToFleet:
    type: String, label: ()->TAPi18n.__('vehicle.allocatedToFleet')
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  allocatedToFleetFromDate:
    type: Date, label:()->TAPi18n.__('vehicle.allocatedToFleetFromDate')
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  color:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.color')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  odometer:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.odometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  engineHours:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.engineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"


  unitId:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.unitId')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  nextTechnicalCheck:
    type: Date, label:()->TAPi18n.__('vehicle.nextTechnicalCheck')
    autoform:
      type: "bootstrap-datepicker",
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  category:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.category')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  make:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.make')
    autoform:
      firstOption: "(Select)"
      options: -> VehiclesMakes.find().map (make) -> label: make.name, value: make._id
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  model:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.model')
    autoform:
      firstOption: "(Select)"
      allowOptions: "true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  kind:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.kind')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxPower:
    type: Number, optional: true,label:()->TAPi18n.__('vehicle.maxPower')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  fuelType:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.fuelType')
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
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  productionYear:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.productionYear')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  body:
    type: String, optional: true, label:()->TAPi18n.__('vehicle.body')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  engineDisplacement:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.engineDisplacement')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxFuelCapacity:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.maxFuelCapacity')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxSpeed:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.maxSpeed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxAllowedSpeed:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.maxAllowedSpeed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  mass:
    type: Number, optional: true, label:()->TAPi18n.__('vehicle.mass')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  workingSchedule:
    type: [Object], optional:true

  "workingSchedule.$.from":
    type: String, optional:true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  "workingSchedule.$.to":
    type: String, optional:true, autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  "alarms.speedingAlarmActive":
    type: Boolean, label: "Speeding", optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-9", "input-col-class": "col-sm-3", "leftLabel": "true"

  "alarms.speedingAlarmSpeed":
    type: Number, label:"Speed", optional:true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-3", "input-col-class": "col-sm-9"

  "alarms.idleAlarmActive":
    type: Boolean, label: "Idling", optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-9", "input-col-class": "col-sm-3", "leftLabel": "true"

  "alarms.idleAlarmTime":
    type: Number, label: "Time", optional:true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-3", "input-col-class": "col-sm-9"
