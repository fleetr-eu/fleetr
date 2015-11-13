Template.maintenanceTypes.onRendered ->
  Session.set 'selectedMaintenanceTypeId', null

Template.maintenanceTypes.events
  'click .deleteMaintenanceType': ->
    Meteor.call 'removeMaintenanceType', Session.get('selectedMaintenanceTypeId')
    Session.set 'selectedMaintenanceTypeId', null
  'rowsSelected': (e, t) ->
    Session.set 'selectedMaintenanceTypeId', e.fleetrGrid.data[e.rowIndex]._id

Template.maintenanceTypes.helpers
  selectedMaintenanceTypeId: -> Session.get('selectedMaintenanceTypeId')
  maintenanceTypesConfig: ->
    cursor: MaintenanceTypes.find()
    columns: [
      id: "name"
      field: "name"
      name: "#{TAPi18n.__('maintenanceTypes.name')}"
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "description"
      field: "description"
      name: "#{TAPi18n.__('maintenanceTypes.description')}"
      width:120
      sortable: true
      search: where: 'client'
    ,
      id: "nextMaintenanceMonths"
      field: "nextMaintenanceMonths"
      name: "#{TAPi18n.__('maintenanceTypes.nextMaintenanceMonths')}"
      width:20
      sortable: true
      search: where: 'client'
      align: "right"
     ,
      id: "nextMaintenanceKMs"
      field: "nextMaintenanceKMs"
      name: "#{TAPi18n.__('maintenanceTypes.nextMaintenanceKMs')}"
      width:20
      sortable: true
      align: "right"
      search: where: 'client'
     ,
      id: "nextMaintenanceEngineHours"
      field: "nextMaintenanceEngineHours"
      name: "#{TAPi18n.__('maintenanceTypes.nextMaintenanceEngineHoursShort')}"
      width:20
      sortable: true
      align: "right"
      search: where: 'client'    
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
