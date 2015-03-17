Template.maintenanceTypes.created = ->
  Session.setDefault 'maintenanceTypeFilter', ''

Template.maintenanceTypes.events
  'click .deleteMaintenanceType': ->
    Meteor.call 'removeMaintenanceType', Session.get('selectedMaintenanceTypeId')
    Session.set 'selectedMaintenanceTypeId', null

Template.maintenanceTypes.helpers
  maintenanceTypes: -> MaintenanceTypes.findFiltered 'maintenanceTypeFilter', ['name', 'description']
  selectedMaintenanceTypeId: -> Session.get('selectedMaintenanceTypeId')

Template.maintenanceTypeTableRow.helpers
  active: -> if @_id == Session.get('selectedMaintenanceTypeId') then 'active' else ''

Template.maintenanceTypeTableRow.events
  'click tr': -> Session.set 'selectedMaintenanceTypeId', @_id
