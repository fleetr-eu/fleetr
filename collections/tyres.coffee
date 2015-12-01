@Tyres = new Mongo.Collection 'tyres'
Partitioner.partitionCollection Tyres

Tyres.attachSchema new SimpleSchema
  _id:
    type: String
    optional: true
  width:
    type: Number
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  height:
    type: Number
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  innerDiameter:
    type: Number
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  loadIndex:
    type: Number
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  speedIndex:
    type: String
    optional: true
    autoform:
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  active:
    type: Boolean
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'small'
          onColor: 'success'
      leftLabel:"true"
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
  vehicle:
    type: String
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
      template: "bootstrap3-horizontal"
      "label-class": "col-sm-5"
      "input-col-class": "col-sm-7"
