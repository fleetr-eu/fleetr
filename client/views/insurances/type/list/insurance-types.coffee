Template.insuranceTypes.onRendered ->
  Session.set 'selectedInsuranceTypesId', null

options =
  backdrop: 'static'
  keyboard: false

Template.insuranceTypes.events
  'click .deleteInsuranceType': (e, t) ->
    data =
      title: -> TAPi18n.__ 'insuranceTypes.title'
      message: -> TAPi18n.__ 'insuranceTypes.deleteMessage'
      action: ->
        Meteor.call 'removeInsuranceType', Session.get('selectedInsuranceTypesId'), ->
          Meteor.defer ->
            Session.set 'selectedInsuranceTypesId', t.grid.data[t.row]?._id
    Modal.show 'confirmDelete', data, options
  'rowsSelected': (e, t) ->
    [t.grid, t.row] = [e.fleetrGrid, e.rowIndex]
    Session.set 'selectedInsuranceTypesId', t.grid.data[t.row]._id
  'click .edit-insuranceType': -> Modal.show 'insuranceType', {doc: InsuranceTypes.findOne(_id: Session.get('selectedInsuranceTypesId'))}, options
  'click .add-insuranceType': -> Modal.show 'insuranceType', {}, options

Template.insuranceTypes.helpers
  selectedInsuranceTypesId: -> Session.get('selectedInsuranceTypesId')

Template.insuranceTypes.helpers
  insuranceTypesConfig: ->
    columns: [
      id: "insuranceTypes"
      field: "name"
      name: "#{TAPi18n.__('insuranceTypes.name')}"
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "description"
      field: "description"
      name:  "#{TAPi18n.__('insuranceTypes.description')}"
      width:120
      sortable: true
      search: where: 'client' 
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    cursor: InsuranceTypes.find()

