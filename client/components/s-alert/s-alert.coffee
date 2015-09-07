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
    console.log "AutoForm::success formType='#{formType}'", result, @
    sAlert.success sAlertIcon: 'check', sAlertTitle: 'Saved', message: 'Saved successfully.'
  onError: (formType, error) ->
    console.log "AutoForm::error formType='#{formType}'", error, @
    if formType == 'pre-submit validation'
      sAlert.warning sAlertIcon: 'asterisk', sAlertTitle: 'Validation', message: 'Please complete the form.'
    else
      sAlert.error sAlertIcon: 'exclamation', sAlertTitle: 'An error occured', message: 'Could not save form data.'
