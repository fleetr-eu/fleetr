Meteor.startup ->
  Vehicles._ensureIndex
    name: 'text'
    licensePlate: 'text'
    identificationNumber: 'text'
    tags: 'text'
    
