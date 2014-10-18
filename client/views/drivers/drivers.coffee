Template.drivers.events
  'click .deleteDriver': -> Meteor.call 'removeDriver', @_id

Template.drivers.helpers
  drivers: -> Drivers.find()
