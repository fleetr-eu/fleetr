Template.drivers.created = ->
  Session.set 'driverFilter', ''

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
  selectedDriverId: -> Session.get('selectedDriverId')

Template.drivers.events
  'click tr': (event, tpl) ->
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    Session.set 'selectedDriverId', rowData._id
