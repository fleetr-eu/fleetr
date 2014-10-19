Template.drivers.events
  'click .deleteDriver': -> Meteor.call 'removeDriver', @_id

Template.drivers.helpers
  drivers: -> Drivers.find()

Template.driverTableRow.helpers
  fullName: -> "#{@firstName || ''} #{@name || ''}"
  licenseCats: ->
    if @categories
      (@categories.map (cat) -> cat.license).toString()
    else ''
