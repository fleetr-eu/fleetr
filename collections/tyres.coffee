@Tyres = new Mongo.Collection 'tyres'

Tyres.attachSchema new SimpleSchema
  _id:
    type: String
    optional: true
  width:
    type: Number
  height:
    type: Number
  innerDiameter:
    type: Number
  loadIndex:
    type: Number
    optional: true
  speedIndex:
    type: String
    optional: true
  active:
    type: Boolean
    autoform:
      template: "bootstrap3-horizontal"
      "leftLabel": "true"
  vehicle:
    type: String
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
