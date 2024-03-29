SimpleSchema.messages
  invalidFromToDates: "Несъответствие в датите"
  invalidFromToKM: "Несъответствие в километрите"
  invalidFromToHours: "Несъответствие в часовете"
  unitAlreadyExists: "Това устройство вече е асоциирано с друг автомобил"
  required: "'[label]' е задължително поле"
  minString: "'[label]' трябва да бъде поне [min] символа"
  maxString: "'[label]' не може да бъде повече от [max] символа"
  minNumber: "'[label]' трябва да бъде поне [min]"
  maxNumber: "'[label]' не може да бъде повече от [max]"
  minDate: "'[label]' трябва да бъде след [min]"
  maxDate: "'[label]' не може да бъде след [max]"
  minCount: "Трябва да изберете минумум [minCount] стойности"
  maxCount: "Не можете да избирате повече от [maxCount] стойности"
  noDecimal: "'[label]' трябва да бъде цяло число"
  notAllowed: "[value] не е позволена стойност"
  expectedString: "'[label]' трябва да бъде текс"
  expectedNumber: "'[label]' трябва да бъде число"
  expectedBoolean: "'[label]' трябва да бъде Да или Не"
  expectedArray: "'[label]' трябва да бъде масив"
  expectedObject: "'[label]' трябва да бъде обект"
  expectedConstructor: "'[label]' трябва да е от тип [type]"
  keyNotInSchema: "'[label]'не е позволено от дефиниращата схема"
  regEx: [
    msg: "[label] failed regular expression validation"
    exp: SimpleSchema.RegEx.Email, msg: "'[label]'трябва да бъде валиден е-мейл адрес"
    exp: SimpleSchema.RegEx.WeakEmail, msg: "'[label]' трябва да бъде валиден е-мейл адрес"
    exp: SimpleSchema.RegEx.Domain, msg: "'[label]' трябва да бъде валиден домйен"
    exp: SimpleSchema.RegEx.WeakDomain, msg: "'[label]' трябва да бъде валиден домйен"
    exp: SimpleSchema.RegEx.IP, msg: "'[label]' трябва да бъде валиден IP адрес"
    exp: SimpleSchema.RegEx.IPv4, msg: "'[label]' трябва да бъде валиден IPv4 адрес"
    exp: SimpleSchema.RegEx.IPv6, msg: "'[label]'] трябва да бъде валиден IPv6 адрес"
    exp: SimpleSchema.RegEx.Url, msg: "'[label]' трябва да бъде валиден URL"
    exp: SimpleSchema.RegEx.Id, msg: "'[label]' трябва да съдържа само букви и чифри"
  ]
