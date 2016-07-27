Meteor.startup ->
  sAlert.config
    effect: 'genie',
    position: 'bottom-right'
    timeout: 5000
    html: true
    onRouteClose: true
    stack: true

AutoForm.addHooks [
    'vehicleForm', 'maintenancesForm', 'fleetGroupForm', 'fleetForm', 'expenseTypeForm',
    'expenseGroupForm', 'expensesForm', 'driverForm', 'driverVehicleAssignmentForm', 'insertAlarmDefinition'
  ],
  onSuccess: (formType, result) ->
    sAlert.success sAlertIcon: 'check', sAlertTitle: TAPi18n.__('alerts.saved.title'), message: TAPi18n.__('alerts.saved.message')
  onError: (formType, error) ->
    if formType == 'pre-submit validation'
      sAlert.warning sAlertIcon: 'asterisk', sAlertTitle: TAPi18n.__('alerts.validation.title'), message: TAPi18n.__('alerts.validation.message')
    else
      sAlert.error sAlertIcon: 'exclamation', sAlertTitle: TAPi18n.__('alerts.error.title'), message: TAPi18n.__('alerts.error.message')
