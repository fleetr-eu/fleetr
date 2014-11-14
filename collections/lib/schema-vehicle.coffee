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

  identificationNumber:
    type: String
    label: "Идентификационен номер (VIN)"
    optional: true

  allocatedToFleet:
    type: String
    label: "Автопарк"
    autoform:
      firstOption: "(Изберете)"
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id

  allocatedToFleetFromDate:
    type: Date
    label: "В автопарка от"
    autoform:
      type: "bootstrap-datepicker"

  lastLocation:
    type: Object
    optional: true
    blackbox: true

  workingSchedule:
    type: [Object]
    optional:true

  "workingSchedule.$.from":
    type: String,
    optional:true

  "workingSchedule.$.to":
    type: String,
    optional:true

  category:
    type: String
    label: 'Категория'
    optional: true

  body:
    type: String
    label: 'Каросерия'
    optional: true

  make:
    type: String
    label: 'Марка'
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> VehiclesMakes.find().map (make) -> label: make.name, value: make._id

  model:
    type: String
    label: 'Модел'
    optional: true
    autoform:
      firstOption: "(Изберете)"

  type:
    type: String
    label: 'Тип'
    optional: true

  mass:
    type: String
    label: 'Маса (кг)'
    optional: true

  engine:
    type: Object
    optional: true;

  "engine.type":
    type: String
    label: "Тип"
    optional: true

  "engine.powerSource":
    type: String
    label: "Силов агрегат"
    optional: true

  "engine.cylinder":
    type: Number
    label: "Цилиндър (cm3)"
    optional: true

  "engine.maxPower":
    type: Number
    label: "Максимална мощност (Kw)"
    optional: true

  "еngine.traction":
    type: Number
    label: "Тягово усилие"
    optional: true

  "engine.axes":
    type: Number
    label: "Брой оси"
    optional: true

  "engine.noiseLevel":
    type: Object
    optional: true

  "engine.noiseLevelTravelling":
    type: Number
    label: "Шум при пътуване (dB(A))"
    optional: true

  "engine.noiseLevelIdling":
    type: Number
    label: "Шум на празен ход (dB(A))"
    optional: true

  brakeAirPressure:
    type: Object
    optional: true

  "brakeAirPressure.singlePipes":
    type: Number
    label: "Единични тръби (bar)"
    optional: true

  "brakeAirPressure.twoPipes":
    type: Number
    label: "Двойни тръби (bar)"
    optional: true

  maxSpeed:
    type: Number
    label: "Максимална скорост (KM/h)"
    optional: true
