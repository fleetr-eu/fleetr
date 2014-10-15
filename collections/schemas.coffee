@Schema = {};
Schema.driver = new SimpleSchema
  name:
    type: String
    label: "Name"
  firstName:
    type: String
    label: "First Name"
  ssn:
    type: Number
    label: "SSN"
  birthDate:
    type: Date
    label: "Birth Date"
  sex:
    type: Boolean
    label: "Sex"
  title:
    type: String
    label: "Title"
  idSerial:
    type: String
    label: "ID Serial"
  idNo:
    type: Number
    label: "ID No."
  validFrom:
    type: String
    label: "Valid from"
  validTo:
    type: String
    label: "Valid to"
  issuedBy:
    type: String
    label: "Issued by"
  birthPlace:
    type: String
    label: "Birth place"
  bloodGroup:
    type: String
    label: "Blood group"
    autoform:
      options: [
        {label:"0", value:"0"},
        {label:"A", value:"A"},
        {label:"B", value:"B"},
        {label:"AB", value:"AB"}
      ]
  city:
    type: String
    label: "City"
  address:
    type: String
    label: "Address"
