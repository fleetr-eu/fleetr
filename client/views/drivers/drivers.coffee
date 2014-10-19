Template.drivers.events
  'click .deleteDriver': -> Meteor.call 'removeDriver', @_id

Template.drivers.helpers
  drivers: ->
    filter =
      $regex: "#{Session.get('driverFilter').trim()}"
      $options: 'i'
    Drivers.find $or: [{name: filter}, {firstName: filter}]

Template.driverTableRow.helpers
  fullName: -> "#{@firstName || ''} #{@name || ''}"
  licenseCats: ->
    if @categories
      (@categories.map (cat) -> cat.license).toString()
    else ''
