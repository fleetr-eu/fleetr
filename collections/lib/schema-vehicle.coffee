Schema.vehicle = new SimpleSchema
  _id:
    type: String
    optional: true

  state:
    type: String
    optional: true

  lat:
    type: Number
    optional: true

  lon:
    type: Number
    optional: true

  speed:
    type: Number
    optional: true

  tags:
    type: String
    optional: true
    label: 'Tags'

  active:
    type: Boolean
    label: "Active"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"
      "leftLabel": "true"

  name:
    type: String
    label: 'Name'
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  licensePlate:
    type: String
    label: 'Regitration No'
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  identificationNumber:
    type: String
    label: "Identification No (VIN)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  engineNumber:
    type: String
    label: "Engine No"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  allocatedToFleet:
    type: String
    label: "Fleet"
    autoform:
      firstOption: "(Select)"
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  allocatedToFleetFromDate:
    type: Date
    label: "In the fleet since"
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  color:
    type: String
    label: "Color"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  odometer:
    type: Number
    label: "Odometer (km)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  unitId:
    type: String
    label: "Unit Id"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  nextTechnicalCheck:
    type: Date
    label: "Next technical check"
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  category:
    type: String
    label: 'Category'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  make:
    type: String
    label: 'Make'
    optional: true
    autoform:
      firstOption: "(Select)"
      options: -> VehiclesMakes.find().map (make) -> label: make.name, value: make._id
      allowOptions: "true"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  model:
    type: String
    label: 'Model'
    optional: true
    autoform:
      firstOption: "(Select)"
      allowOptions: "true"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  kind:
    type: String
    label: 'Kind'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  maxPower:
    type: Number
    label: "Max power (kW)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  fuelType:
    type: String
    label: "Fuel type"
    optional: true
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
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  productionYear:
    type: Number
    label: "Production Year"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  body:
    type: String
    label: 'Body'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  engineDisplacement:
    type: Number
    label: "Engine Displacement (cc)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  maxFuelCapacity:
    type: Number
    label: "Max fuel capacity (l)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  maxSpeed:
    type: Number
    label: "Max speed (km/h)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  maxAllowedSpeed:
    type: Number
    label: "Max allowed speed (km/h)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"


  mass:
    type: Number
    label: 'Mass (kg)'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  workingSchedule:
    type: [Object]
    optional:true

  "workingSchedule.$.from":
    type: String,
    optional:true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "workingSchedule.$.to":
    type: String,
    optional:true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  speed:
    type: Number
    label: "Speed"
    decimal: true
    optional: true

  lastUpdate:
    type: Date
    label: "Last Update"
    optional: true

  lat:
    type: Number
    label: "Lat"
    decimal: true
    optional: true

  lon:
    type: Number
    label: "Lon"
    decimal: true
    optional: true

  status:
    type: String,
    optional:true
