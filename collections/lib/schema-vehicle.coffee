Schema.vehicle = new SimpleSchema
  _id:
    type: String
    optional: true

  tags:
    type: String
    optional: true
    label: 'Етикети'

  licensePlate:
    type: String
    label: 'Регистрационен номер'
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  identificationNumber:
    type: String
    label: "Идентификационен номер (VIN)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  allocatedToFleet:
    type: String
    label: "Автопарк"
    autoform:
      firstOption: "(Изберете)"
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  allocatedToFleetFromDate:
    type: Date
    label: "В автопарка от"
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  lastLocation:
    type: Object
    optional: true
    blackbox: true

  category:
    type: String
    label: 'Категория'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  body:
    type: String
    label: 'Каросерия'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  make:
    type: String
    label: 'Марка'
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> VehiclesMakes.find().map (make) -> label: make.name, value: make._id
      allowOptions: "true"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  model:
    type: String
    label: 'Модел'
    optional: true
    autoform:
      firstOption: "(Изберете)"
      allowOptions: "true"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  type:
    type: String
    label: 'Тип'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  mass:
    type: String
    label: 'Маса (кг)'
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  maxSpeed:
    type: Number
    label: "Максимална скорост (KM/h)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  engine:
    type: Object
    optional: true;
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.type":
    type: String
    label: "Тип"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.powerSource":
    type: String
    label: "Силов агрегат"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.cylinder":
    type: Number
    label: "Цилиндър (cm3)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.maxPower":
    type: Number
    label: "Максимална мощност (Kw)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "еngine.traction":
    type: Number
    label: "Тягово усилие"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.axes":
    type: Number
    label: "Брой оси"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.noiseLevel":
    type: Object
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.noiseLevelTravelling":
    type: Number
    label: "Шум при пътуване (dB(A))"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "engine.noiseLevelIdling":
    type: Number
    label: "Шум на празен ход (dB(A))"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  brakeAirPressure:
    type: Object
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "brakeAirPressure.singlePipes":
    type: Number
    label: "Единични тръби (bar)"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-6"
      "input-col-class": "col-sm-6"

  "brakeAirPressure.twoPipes":
    type: Number
    label: "Двойни тръби (bar)"
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
