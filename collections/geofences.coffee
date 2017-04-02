@Geofences = new Mongo.Collection 'geofences'
Schema.geofences = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: -> TAPi18n.__('common.name')

  tags:
    type: String
    label: -> TAPi18n.__('common.tags')
    optional: true

  center:
    type: [Number]
    decimal: true

  radius:
    type: Number
    decimal: true

Geofences.attachSchema Schema.geofences
