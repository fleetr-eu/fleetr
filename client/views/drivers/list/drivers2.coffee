columns = [
  id: "name"
  field: "name"
  name: "name"
  width:120
  sortable: true
,
  id: "firstname"
  field: "firstName"
  name: "firstname"
  width:120
  sortable: true
]

options =
  enableCellNavigation: true
  enableColumnReorder: false
  showHeaderRow: false
  headerRowHeight: 30
  explicitInitialization: true
  forceFitColumns: true

Template.drivers2.helpers
  grid:  ->
    cursor = Drivers.findFiltered Session.get('driverFilter'), ['firstName', 'name', 'tags']
    new FleetrGrid options, columns, cursor
  pageTitle: -> "#{TAPi18n.__('drivers.title')}"

Template.drivers2.events
  'createLinkClicked #driversList':  (e) -> console.log 'drivers2 createLink'
  'editLinkClicked #driversList':    (e) -> console.log 'drivers2 editLink', e.document
  'deleteLinkClicked #driversList':  (e) -> console.log 'drivers2 deleteLink', e.document
