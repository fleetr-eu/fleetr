@Schema = {};
SimpleSchema.messages
  validToBeforeValidFrom: 'Valid to date must be after valid from date!'

Schema.driver = new SimpleSchema
  _id:
    type: String
    optional: true
  picture:
    type: String
    label: 'Снимка'
    optional: true
  tags:
    type: String
    optional: true
    label: 'Етикети'
  name:
    type: String
    label: 'Фамилия'
  firstName:
    type: String
    label: "Име"
    optional: true
  ssn:
    type: Number
    label: "ЕГН / Личен номер"
    optional: true
  birthDate:
    type: Date
    label: "Дата на раждане"
    optional: true
  sex:
    type: String
    label: "Пол"
    optional: true
    allowedValues: ['Мъж', 'Жена']
  idType:
    type: String
    label: "Вид"
    optional: true
    allowedValues: ['Лична карта', 'Паспорт']
  idSerial:
    type: String
    label: "Серия"
    optional: true
  idNo:
    type: Number
    label: "Номер"
    optional: true
  validFrom:
    type: Date
    label: "Валиден от"
    optional: true
  validTo:
    type: Date
    label: "Валиден до"
    optional: true
    custom: -> if @value < @field('validFrom').value then 'validToBeforeValidFrom'
  issuedBy:
    type: String
    label: "Издаден от"
    optional: true
  birthPlace:
    type: String
    label: "Място на раждане"
    optional: true
  bloodGroup:
    type: String
    label: "Кръвна група"
    optional: true
    allowedValues: ['A', 'B', '0', 'AB']
  city:
    type: String
    label: "Град"
    optional: true
  address:
    type: String
    label: "Адрес"
    optional: true
  county:
    type: String
    label: "Област"
    optional: true
  country:
    type: String
    label: "Държава"
    optional: true
    autoform:
      options: -> Countries.find().map (country) -> label: country.name, value: country._id
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    label: "е-мейл"
    optional: true
  mobile:
    type: String
    label: "Мобилен телефон"
    optional: true
  phone:
    type: String
    label: "Домашен телефон"
    optional: true
  officePhone:
    type: String
    label: "Офис телефон"
    optional: true
  licenseIssueDate:
    type: Date
    label: "Дата на издаване"
    optional: true
  licenseExpieryDate:
    type: Date
    label: "Валидно до"
    optional: true
  categoryA:
    type: Boolean
    optional: true
    label: 'A'
  categoryAIssueDate:
    type: Date
    optional: true
    label: 'от дата'
  categoryB:
    type: Boolean
    optional: true
    label: 'B'
  categoryBIssueDate:
    type: Date
    optional: true
    label: 'от дата'
  categoryC:
    type: Boolean
    optional: true
    label: 'C'
  categoryCIssueDate:
    type: Date
    optional: true
    label: 'от дата'
  categoryD:
    type: Boolean
    optional: true
    label: 'D'
  categoryDIssueDate:
    type: Date
    optional: true
    label: 'от дата'
  categoryE:
    type: Boolean
    optional: true
    label: 'E'
  categoryEIssueDate:
    type: Date
    optional: true
    label: 'от дата'
  medEvalExpieryDate:
    type: Date
    label: "Медицинско свидетелство: Валидно до"
    optional: true
  profCertExpieryDate:
    type: Date
    label: "Професионален сертификат: Валиден до"
    optional: true
  psychApprovalExpieryDate:
    type: Date
    label: "Удостоверението за психологическа годност: Валидно до"
    optional: true
  transportLicense:
    type: String
    label: "Транспортен лиценз"
    optional: true
  education:
    type: String
    label: "Образование"
    optional: true
    allowedValues: ['', 'Предучилищно', 'Основно', 'Средно', 'Висше']
  ownsPersonalLicense:
    type: Boolean
    label: "Притежева личен лиценз"
    optional: true
  ownVehicle:
    type: String
    label: "Собствено МПС"
    optional: true
  active:
    type: Boolean
    label: "Активен"
    optional: true

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
      options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id

  allocatedToFleetFromDate:
    type: Date
    label: "В автопарка от"

  workingSchedule:
    type: [Object]
    optional:true
    
  "workingSchedule.$.from":
    type: Date,
    optional:true

  "workingSchedule.$.to":
    type: Date,
    optional:true

Schema.company = new SimpleSchema
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
      options: -> Companies.find().map (group) -> label: group.name, value: group._id

Schema.expenses = new SimpleSchema
       driver:
          type: String
          label: 'Шофьор'
          autoform:
            options: -> Drivers.find().map (driver) -> label: driver.name, value: driver._id
       vehicle:
          type:String
          label: "Автомобил"
          autoform:
            options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
       invoiceNr:
          type:String
          label: "Фактура/Касова бележка №"
       date:
          type:Date
          label: "Дата"
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
      options: -> Drivers.find().map (driver) ->
        { label: driver.firstName+" "+driver.name, value: driver._id}
  eventType:
    type:String
    label: "Събитие"
    autoform:
      options: -> EventTypes.find().map (event) -> label: event.name, value: event._id
  date:
    type:Date
    label: "Дата"
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
      optional: true
      autoform:
        options: -> Drivers.find().map (driver) ->
          { label: driver.firstName+" "+driver.name, value: driver._id}
   vehicle:
      type:String
      label: "Автомобил"
      optional: true
      autoform:
        options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
   beginAssignmentTime:
      type:Date
      label: "От"
      optional: true
   endAssignmentTime:
      type:Date
      label: "До"
      optional: true
