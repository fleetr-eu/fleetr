
Template.drivers.events
  'click .deleteDriver': -> Meteor.call 'removeDriver', @_id
  'keyup input.search-query': -> Session.set 'filterDrivers', $('#filterDrivers').val()

Template.drivers.helpers
  drivers: ->
    filter =
      $regex: "#{Session.get('filterDrivers').trim()}".replace ' ', '|'
      $options: 'i'
    Drivers.find $or: [{name: filter}, {firstName: filter}]
  search: -> Session.get('filterDrivers')
    
Template.driverTableRow.helpers
  fullName: -> "#{@firstName || ''} #{@name || ''}"
  licenseCats: ->
    if @categories
      (@categories.map (cat) -> cat.license).toString()
    else ''
