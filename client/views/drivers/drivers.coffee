Template.drivers.created = -> Session.set 'driverFilter', ''

Template.drivers.events
  'click .deleteDriver': ->
    Meteor.call 'removeDriver', Session.get('selectedDriverId')
    Session.set 'selectedDriverId', null

Template.drivers.helpers
  drivers: ->
    q = Session.get('driverFilter').trim()
    filter =
      $regex: q.replace ' ', '|'
      $options: 'i'
    Drivers.find $or: [{firstName: filter}, {name: filter}, {tags: {$elemMatch: filter}}]
  selectedDriverId: -> Session.get('selectedDriverId')

Template.driverTableRow.helpers
  fullName: -> "#{@firstName} #{@name}"
  active: -> if @_id == Session.get('selectedDriverId') then 'active' else ''

Template.driverTableRow.events
  'click tr': -> Session.set 'selectedDriverId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#drivers #filter').val(tag)
    Session.set 'driverFilter', tag
