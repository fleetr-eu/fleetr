SimpleSchema.messages
  validToBeforeValidFrom: "'Валиден до' трябва да бъде след 'Валиден от'"

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
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  name:
    type: String
    label: 'Фамилия'
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  firstName:
    type: String
    label: "Име"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  ssn:
    type: Number
    label: "ЕГН / Личен номер"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  birthDate:
    type: Date
    label: "Дата на раждане"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  sex:
    type: String
    label: "Пол"
    optional: true
    allowedValues: ['Мъж', 'Жена']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

  education:
    type: String
    label: "Образование"
    optional: true
    allowedValues: ['', 'Предучилищно', 'Основно', 'Средно', 'Висше']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

  active:
    type: Boolean
    label: "Активен"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"

  idType:
    type: String
    label: "Вид"
    optional: true
    allowedValues: ['Лична карта', 'Паспорт']
    autoform:
      firstOption: "(Изберете)"
      options: "allowed"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  idSerial:
    type: String
    label: "Серия"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  idNo:
    type: Number
    label: "Номер"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  validFrom:
    type: Date
    label: "Валиден от"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  validTo:
    type: Date
    label: "Валиден до"
    optional: true
    custom: -> if @value < @field('validFrom').value then 'validToBeforeValidFrom'
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  issuedBy:
    type: String
    label: "Издаден от"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  birthPlace:
    type: String
    label: "Място на раждане"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  bloodGroup:
    type: String
    label: "Кръвна група"
    optional: true
    allowedValues: ['A', 'B', '0', 'AB']
    autoform:
      firstOption: "(Изберете)"
      options: "allowed"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  city:
    type: String
    label: "Град"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  address:
    type: String
    label: "Адрес"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  county:
    type: String
    label: "Област"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  country:
    type: String
    label: "Държава"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    label: "е-мейл"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  mobile:
    type: String
    label: "Мобилен телефон"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  phone:
    type: String
    label: "Домашен телефон"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  officePhone:
    type: String
    label: "Офис телефон"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  licenseIssueDate:
    type: Date
    label: "Дата на издаване"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  licenseExpieryDate:
    type: Date
    label: "Валидно до"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  categoryA:
    type: Boolean
    optional: true
    label: 'A'
    autoform:
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-1"
  categoryAIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-3"
      "input-col-class": "col-sm-7"
  categoryB:
    type: Boolean
    optional: true
    label: 'B'
    autoform:
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-1"
  categoryBIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-3"
      "input-col-class": "col-sm-7"
  categoryC:
    type: Boolean
    optional: true
    label: 'C'
    autoform:
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-1"
  categoryCIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-3"
      "input-col-class": "col-sm-7"
  categoryD:
    type: Boolean
    optional: true
    label: 'D'
    autoform:
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-1"
  categoryDIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-3"
      "input-col-class": "col-sm-7"
  categoryE:
    type: Boolean
    optional: true
    label: 'E'
    autoform:
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-1"
  categoryEIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-3"
      "input-col-class": "col-sm-7"

  medEvalExpieryDate:
    type: Date
    label: "Медицинско свидетелство: "
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  profCertExpieryDate:
    type: Date
    label: "Професионален сертификат: "
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  psychApprovalExpieryDate:
    type: Date
    label: "У-ние за психо годност: "
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  transportLicense:
    type: String
    label: "Транспортен лиценз"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  ownsPersonalLicense:
    type: Boolean
    label: "Личен лиценз"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  ownVehicle:
    type: String
    label: "Собствено МПС"
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  vehicle_id:
    type: String
    optional: true
