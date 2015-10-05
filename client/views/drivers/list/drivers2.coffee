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
  ]
  options:
    enableCellNavigation: true
    enableColumnReorder: false
    showHeaderRow: true
    headerRowHeight: 30
    explicitInitialization: true
    forceFitColumns: true
  cursor: Drivers.findFiltered Session.get('driverFilter'), ['firstName', 'name', 'tags']

Template.drivers2.helpers
  grid:  ->
    new FleetrGrid options, columns, cursor
  fleetrGridConfig: fleetrGridConfig
  pageTitle: -> "#{TAPi18n.__('drivers.title')}"

Template.drivers2.events
  'createLinkClicked #driversList':  (e) -> console.log 'drivers2 createLink'
  'editLinkClicked #driversList':    (e) -> console.log 'drivers2 editLink', e.document
  'deleteLinkClicked #driversList':  (e) -> console.log 'drivers2 deleteLink', e.document
