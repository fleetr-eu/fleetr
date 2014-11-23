@Geofences = new Mongo.Collection 'geofences'

Schema.geofences = new SimpleSchema
  _id:
    type: String
    optional: true

  name:
    type: String
    label: 'Обект'

  tags:
    type: String
    label: 'Етикети'
    optional: true

  center:
    type: [Number]
    decimal: true

  radius:
    type: Number
    decimal: true

Geofences.attachSchema Schema.geofences
