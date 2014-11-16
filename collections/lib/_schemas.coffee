@Schema = {};

Schema.fleetGroups = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Група'

Schema.fleet = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Автопарк'
  parent:
    type:String
    label: 'Група'
    autoform:
      firstOption: "(Изберете)"
      options: -> FleetGroups.find().map (group) -> label: group.name, value: group._id

Schema.expenses = new SimpleSchema
   driver:
      type: String
      label: 'Шофьор'
      autoform:
        firstOption: "(Изберете)"
        options: -> Drivers.find().map (driver) ->
          label: driver.firstName+" "+driver.name, value: driver._id
   vehicle:
      type:String
      label: "Автомобил"
      autoform:
        firstOption: "(Изберете)"
        options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
   invoiceNr:
      type:String
      label: "Фактура/Касова бележка №"
   date:
      type:Date
      label: "Дата"
      autoform:
        type: "datetimepicker"
   fuelType:
      type:String
      label: "Вид гориво"
      allowedValues:  ['Бензин', 'Дизел', 'Газ пропан бутан', 'Метан']
   litres:
      type: Number
      label: "Литри"
   pricePerLitre:
      type: Number
      decimal:true
      label: "Цена за литър"
   vatIncluded:
      type: Boolean
      label: "Цената е с ДДС?"
      optional: true
   totalVATIncluded:
      type: Number
      decimal:true
      label: "Общо сума"
   mileage:
      type:Number
      label: "Километраж"
   gasStationName:
      type:String
      label: "Бензиностанция"

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
      label: 'Шофьор'
      autoform:
        firstOption: "(Изберете)"
        options: -> Drivers.find().map (driver) ->
          label: driver.firstName+" "+driver.name
          value: driver._id
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   vehicle:
      type:String
      label: "Автомобил"
      autoform:
        firstOption: "(Изберете)"
        options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   moment:
      type:Date
      label: "От"
      autoform:
        type: "datetimepicker"
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
   event:
      type:String
      label:"Асоцииране"
      autoform:
        type: "select-radio-inline"
        template: "bootstrap3-horizontal"
        "label-class":"col-sm-4"
        "input-col-class": "col-sm-8"
        options: () -> [
          {label: "асоцииране", value: "begin"},
          {label: "деасоцииране", value: "end"}
        ]
