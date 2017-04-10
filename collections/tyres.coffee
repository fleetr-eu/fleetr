@Tyres = new Mongo.Collection 'tyres'

Tyres.attachSchema new SimpleSchema
  _id:
    type: String
    optional: true
  brand:
    type: String
    label: ()->TAPi18n.__('tyre.brand')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  width:
    type: Number
    label: ()->TAPi18n.__('tyre.width')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  height:
    type: Number
    label: ()->TAPi18n.__('tyre.height')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  innerDiameter:
    type: Number
    label: ()->TAPi18n.__('tyre.innerDiameter')
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  loadIndex:
    type: Number
    label: ()->TAPi18n.__('tyre.loadIndex')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  speedIndex:
    type: String
    label: ()->TAPi18n.__('tyre.speedIndex')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  usedKm:
    type: Number
    label: ()->TAPi18n.__('tyre.usedKm')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  changeKm:
    type: Number
    label: ()->TAPi18n.__('tyre.changeKm')
    optional: true
    autoform:
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  active:
    label: ()->TAPi18n.__('tyre.active')
    type: Boolean
    autoform:
      type: 'bootstrap-switch'
      afFieldInput:
        switchOptions:
          size: 'small'
          onColor: 'success'
      leftLabel:"true"
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
  vehicle:
    label: ()->TAPi18n.__('tyre.vehicle')
    type: String
    optional: true
    autoform:
      firstOption: "(Изберете)"
      options: -> Vehicles.find().map (vehicle) -> label: vehicle.licensePlate, value: vehicle._id
      template: "bootstrap3-horizontal", "label-class": "col-sm-5", "input-col-class": "col-sm-7 input-group-sm"
