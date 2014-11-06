Template.drivers.created = -> Session.set 'driverFilter', ''

Template.drivers.events
  'click .deleteDriver': ->
    Meteor.call 'removeDriver', Session.get('selectedDriverId')
    Session.set 'selectedDriverId', null

Template.drivers.helpers
  drivers: -> Drivers.findFiltered 'driverFilter', ['firstName', 'name', 'tags']
  selectedDriverId: -> Session.get('selectedDriverId')

Template.driverTableRow.helpers
  fullName: -> "#{@firstName} #{@name}"
  active: -> if @_id == Session.get('selectedDriverId') then 'active' else ''
  tagsArray: -> tagsArray.call @

Template.driverTableRow.events
  'click tr': -> Session.set 'selectedDriverId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#drivers #filter').val(tag)
    Session.set 'driverFilter', tag
