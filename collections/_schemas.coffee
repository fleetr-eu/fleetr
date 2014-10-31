@Schema = {};
SimpleSchema.messages
  validToBeforeValidFrom: 'Valid to date must be after valid from date!'

Schema.driver = new SimpleSchema
  picture:
    type: String
    label: 'Снимка'
    optional: true
  name:
    type: String
    label: 'Фамилия'
  firstName:
    type: String
    label: "Имена"
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
  'categories.$.license':
    label:'Категория'
    type: String
    optional: true
    allowedValues: ['A', 'B', 'C', 'D', 'E']
  'categories.$.issueDate':
    type: Date
    optional: true
    label: 'Дата на издаване'
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
    label: "Психо удостоверение: Валидно до"
    optional: true
  transportLicense:
    type: String
    label: "Транспортен лиценз"
    optional: true
  education:
    type: String
    label: "Образование"
    optional: true
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

Schema.company = new SimpleSchema
  name:
    type: String
    label: 'Група'

Schema.fleet = new SimpleSchema
  name:
    type: String
    label: 'Автопарк'
  parent:
     type:String

Schema.expensesFuel = new SimpleSchema
       driver:
         type: String
         label: 'Шофьор'
         autoform:
           options: -> Drivers.find().map (driver) -> label: driver.name, value: driver._id
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
       mileage:
           type:Number
           label: "Километраж"
       gasStationName:
           type:String
           label:"Бензиностанция"
