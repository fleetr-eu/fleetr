fleetrGridConfig = ->
  columns: [
    id: "name"
    field: "name"
    name: "name"
    width:120
    sortable: true
    search: where: 'client'
  ,
    id: "firstname"
    field: "firstName"
    name: "firstname"
    width:120
    sortable: true
    search: where: 'client'
  ,
    id: "tags"
    field: "tags"
    name: "tags"
    width:120
    sortable: true
    search: where: 'client'
    formatter: FleetrGrid.Formatters.blazeFormatter Template.columnTags
  ]
  options:
    enableCellNavigation: true
    enableColumnReorder: false
    showHeaderRow: true
    explicitInitialization: true
    forceFitColumns: true
  cursor: Drivers.findFiltered Session.get('driverFilter'), ['firstName', 'name', 'tags']

Template.drivers2.helpers
  fleetrGridConfig: fleetrGridConfig
  pageTitle: -> "#{TAPi18n.__('drivers.title')}"

Template.drivers2.events
  'createLinkClicked #driversList':  Meteor.bindEnvironment (e) ->
    Meteor.defer -> Router.go 'addDriver'
  'editLinkClicked #driversList': Meteor.bindEnvironment (e) ->
    Meteor.defer -> Router.go 'editDriver', {driverId: e.document._id}

  'deleteLinkClicked #driversList':  (e) ->
    console.log 'drivers2 deleteLink', e.document
    Meteor.call 'removeDriver', e.document._id

Template.columnTags.helpers
  tagsArray: -> @value?.split(",") || []
