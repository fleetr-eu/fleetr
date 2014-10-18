@Schema = {};
SimpleSchema.messages
  validToBeforeValidFrom: 'Valid to date must be after valid from date!'

Schema.driver = new SimpleSchema
  name:
    type: String
    label: 'Name'
    autoform:
      placeholder: "Family Name"
  firstName:
    type: String
    label: "First Name"
    optional: true
  ssn:
    type: Number
    label: "SSN"
    # optional: true
  birthDate:
    type: Date
    label: "Birth Date"
    optional: true
  sex:
    type: String
    label: "Sex"
    optional: true
    allowedValues: ['Male', 'Female']
  title:
    type: String
    label: "Title"
    optional: true
  idSerial:
    type: String
    label: "ID Serial"
    optional: true
  idNo:
    type: Number
    label: "ID No."
    optional: true
  validFrom:
    type: Date
    label: "Valid From"
    optional: true
  validTo:
    type: Date
    label: "Valid To"
    optional: true
    custom: -> if @value < @field('validFrom').value then 'validToBeforeValidFrom'
  issuedBy:
    type: String
    label: "Issued By"
    optional: true
  birthPlace:
    type: String
    label: "Birth Place"
    optional: true
  bloodGroup:
    type: String
    label: "Blood Type"
    optional: true
    allowedValues: ['A', 'B', '0', 'AB']
  city:
    type: String
    label: "City"
    optional: true
  address:
    type: String
    label: "Address"
    optional: true
  county:
    type: String
    label: "County"
    optional: true
  country:
    type: String
    label: "Country"
    optional: true
    autoform:
      options: -> Countries.find().map (country) -> label: country.name, value: country._id
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    label: "Email"
    optional: true
  mobile:
    type: String
    label: "Mobile"
    optional: true
  phone:
    type: String
    label: "Phone"
    optional: true
  officePhone:
    type: String
    label: "Office Phone"
    optional: true
  licenseIssueDate:
    type: Date
    label: "License Issue Date"
    optional: true
  licenseExpieryDate:
    type: Date
    label: "License Expiery Date"
    optional: true
  'categories':
    type: Object
    label: 'Categories'
    optional: true
    maxCount: 5
  # 'category.$.license':
  #   type: String
  #   optional: true
  #   allowedValues: ['A', 'B', 'C', 'D', 'E']
  # 'category.$.issueDate':
  #   type: Date
  #   optional: true
  #   autoform:
  #     label: false
  medEvalExpieryDate:
    type: Date
    label: "Medical Evaluation Expiery Date"
    optional: true
  profCertExpieryDate:
    type: Date
    label: "Professional Certificate Expiery Date"
    optional: true
  psychApprovalExpieryDate:
    type: Date
    label: "Psychological Approval Expiery Date"
    optional: true
  transportLicense:
    type: String
    label: "Transposrt License"
    optional: true
  education:
    type: String
    label: "Education"
    optional: true
  ownsPersonalLicense:
    type: Boolean
    label: "Owns Personal License"
    # optional: true
  ownVehicle:
    type: String
    label: "Own Vehicle"
    optional: true
  active:
    type: Boolean
    label: "Active"
    optional: true
