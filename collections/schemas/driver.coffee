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
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  name:
    type: String
    label: 'Фамилия'
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  firstName:
    type: String
    label: "Име"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  ssn:
    type: Number
    label: "ЕГН / Личен номер"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  birthDate:
    type: Date
    label: "Дата на раждане"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  sex:
    type: String
    label: "Пол"
    optional: true
    allowedValues: ['Мъж', 'Жена']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"

  education:
    type: String
    label: "Образование"
    optional: true
    allowedValues: ['', 'Предучилищно', 'Основно', 'Средно', 'Висше']
    autoform:
      firstOption: "(Изберете)"
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"

  active:
    type: Boolean
    label: "Активен"
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"

  idType:
    type: String
    label: "Вид"
    optional: true
    allowedValues: ['Лична карта', 'Паспорт']
    autoform:
      firstOption: "(Изберете)"
      options: "allowed"
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  idSerial:
    type: String
    label: "Серия"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  idNo:
    type: Number
    label: "Номер"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  validFrom:
    type: Date
    label: "Валиден от"
    optional: true
    custom: -> 'invalidFromToDates' if (@value and @field('validTo').value) and (@value > @field('validTo').value)
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  validTo:
    type: Date
    label: "Валиден до"
    optional: true
    custom: -> 'invalidFromToDates' if (@value and @field('validFrom').value) and (@value < @field('validFrom').value) 
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  issuedBy:
    type: String
    label: "Издаден от"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  birthPlace:
    type: String
    label: "Място на раждане"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  bloodGroup:
    type: String
    label: "Кръвна група"
    optional: true
    allowedValues: ['A', 'B', '0', 'AB']
    autoform:
      firstOption: "(Изберете)"
      options: "allowed"
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  city:
    type: String
    label: "Град"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  address:
    type: String
    label: "Адрес"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  county:
    type: String
    label: "Област"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  country:
    type: String
    label: "Държава"
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    label: "е-мейл"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  mobile:
    type: String
    label: "Мобилен телефон"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  phone:
    type: String
    label: "Домашен телефон"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  officePhone:
    type: String
    label: "Офис телефон"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  licenseIssueDate:
    type: Date
    label: "Дата на издаване"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  licenseExpieryDate:
    type: Date
    label: "Валидно до"
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  categoryA:
    type: Boolean
    optional: true
    label: 'A'
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-2 input-group-sm"
  categoryAIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-2"
      "input-col-class": "col-sm-7 input-group-sm"
  categoryB:
    type: Boolean
    optional: true
    label: 'B'
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-2 input-group-sm"
  categoryBIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-2"
      "input-col-class": "col-sm-7 input-group-sm"
  categoryC:
    type: Boolean
    optional: true
    label: 'C'
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-2 input-group-sm"
  categoryCIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-2"
      "input-col-class": "col-sm-7 input-group-sm"
  categoryD:
    type: Boolean
    optional: true
    label: 'D'
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-2 input-group-sm"
  categoryDIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-2"
      "input-col-class": "col-sm-7 input-group-sm"
  categoryE:
    type: Boolean
    optional: true
    label: 'E'
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-1"
      "input-col-class": "col-sm-2 input-group-sm"
  categoryEIssueDate:
    type: Date
    optional: true
    label: 'от дата'
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-2"
      "input-col-class": "col-sm-7 input-group-sm"

  medEvalExpieryDate:
    type: Date
    label: "Медицинско свидетелство: "
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  profCertExpieryDate:
    type: Date
    label: "Професионален сертификат: "
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  psychApprovalExpieryDate:
    type: Date
    label: "У-ние за психо годност: "
    optional: true
    autoform:
      type: "bootstrap-datepicker"
      datePickerOptions: Settings.dpOptions
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  transportLicense:
    type: String
    label: "Транспортен лиценз"
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  ownsPersonalLicense:
    type: Boolean
    label: "Личен лиценз"
    optional: true
    autoform:
      type: 'bootstrap-switch'
      afFieldInput: 
        switchOptions:
          size: 'normal'
          onColor: 'success'
          onText: ()->TAPi18n.__('general.yes')
          offText: ()->TAPi18n.__('general.no')
      template: "bootstrap3-horizontal"
      leftLabel:"true"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7 input-group-sm"
  ownVehicle:
    type: String
    label: "Собствено МПС"
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> Vehicles.find({}, {$sort: {"name": 1}}).map (vehicle) -> label: vehicle.name+" ("+vehicle.licensePlate+")", value: vehicle._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  vehicle_id:
    type: String
    optional: true
