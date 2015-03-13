Template.drivers.created = -> 
  Session.set 'driverFilter', ''
  @autorun -> 
    Meteor.subscribe 'drivers'

Template.drivers.events
  'click .deleteDriver': ->
    Meteor.call 'removeDriver', Session.get('selectedDriverId')
    Session.set 'selectedDriverId', null


gettags = (tags)->
  str = ''
  for tag in tags.split(',')
    str += '<span class="label label-danger filter-tag">' + tag + '</span>'
  new Spacebars.SafeString(str)

Template.drivers.helpers
  drivers: -> Drivers.findFiltered 'driverFilter', ['firstName', 'name', 'tags']
  selectedDriverId: -> Session.get('selectedDriverId')
  driversCollection: ()-> Drivers
  driversFields: ()-> [
    {key: 'name', label: 'Name', fn: (val,obj)-> obj.firstName + ' ' + obj.name }
    {key: 'tags', label: 'Tags', fn: (val,obj)-> gettags(obj.tags) }
  ]

# Template.driverTableRow.helpers
#   fullName: -> "#{@firstName} #{@name}"
#   active: -> if @_id == Session.get('selectedDriverId') then 'active' else ''
#   tagsArray: -> tagsAsArray.call @

# Template.driverTableRow.events
#   'click tr': -> Session.set 'selectedDriverId', @_id
#   'click .filter-tag': (e) ->
#     tag = e.target.innerText
#     $('#drivers #filter').val(tag)
#     Session.set 'driverFilter', tag
