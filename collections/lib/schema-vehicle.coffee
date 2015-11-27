Schema.vehicle = new SimpleSchema
  _id:
    type: String
    optional: true

  state:
    optional: true, type: String, label: ()->TAPi18n.__('vehicles.state')
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
    type: String, optional: true, label: ()->TAPi18n.__('vehicles.tags')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  active:
    type: Boolean, optional: true, label: ()->TAPi18n.__('vehicles.active')
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions: 
          size: 'small'
          onColor: 'success'
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  name:
    type: String, label: ()->TAPi18n.__('vehicles.name')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"     

  licensePlate:
    type: String, label: ()->TAPi18n.__('vehicles.licensePlate')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  identificationNumber:
    type: String, label: ()->TAPi18n.__('vehicles.identificationNumber')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  engineNumber:
    type: String, label: ()->TAPi18n.__('vehicles.engineNumber')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  allocatedToFleet:
    type: String, label: ()->TAPi18n.__('vehicles.allocatedToFleet')
    autoform:
      firstOption: ()->TAPi18n.__('dropdown.select')
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  allocatedToFleetFromDate:
    type: Date, label:()->TAPi18n.__('vehicles.allocatedToFleetFromDate')
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  color:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.color')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  odometer:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.odometer')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  engineHours:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.engineHours')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  unitId:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.unitId')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  lastSeen:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.lastSeen')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"      

  phoneNumber:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.phoneNumber')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"      

  nextTechnicalCheck:
    type: Date, label:()->TAPi18n.__('vehicles.nextTechnicalCheck')
    autoform:
      type: "bootstrap-datepicker",
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  category:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.category')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  makeAndModel:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.makeAndModel')
    autoform:
      type: "typeahead"
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"
      options: ->
        Vehicles.find({}, {fields: makeAndModel: 1}).map (v) ->
          label: v.makeAndModel
          value: v.makeAndModel

  kind:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.kind')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxPower:
    type: Number, optional: true,label:()->TAPi18n.__('vehicles.maxPower')
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

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
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  productionYear:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.productionYear')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  body:
    type: String, optional: true, label:()->TAPi18n.__('vehicles.body')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  engineDisplacement:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.engineDisplacement')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxFuelCapacity:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.maxFuelCapacity')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxSpeed:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.maxSpeed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  maxAllowedSpeed:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.maxAllowedSpeed')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-6", "input-col-class": "col-sm-6"

  mass:
    type: Number, optional: true, label:()->TAPi18n.__('vehicles.mass')
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
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions: 
          size: 'small'
          onColor: 'success'
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-9"
      "input-col-class": "col-sm-3"

  "alarms.speedingAlarmSpeed":
    type: Number, label:"Speed", optional:true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-3", "input-col-class": "col-sm-9"

  "alarms.idleAlarmActive":
    type: Boolean, label: "Idling", optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions: 
          size: 'small'
          onColor: 'success'
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-9"
      "input-col-class": "col-sm-3"

  "alarms.idleAlarmTime":
    type: Number, label: "Time", optional:true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-3", "input-col-class": "col-sm-9"

  driver_id:
    type: String
    optional: true
