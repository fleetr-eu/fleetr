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
