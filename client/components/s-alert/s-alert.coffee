Meteor.startup ->
  sAlert.config
    effect: 'genie',
    position: 'bottom-right'
    timeout: 2500
    html: true
    onRouteClose: true
    stack: true

AutoForm.addHooks [
    'vehicleForm'
  ],
  onSuccess: ->
    sAlert.success sAlertIcon: 'asterisk', sAlertTitle: 'Saved', message: 'Created successfully.'
  onError: ->
    sAlert.error sAlertIcon: 'asterisk', sAlertTitle: 'An error occured', message: 'Oh oh, something went wrong.'
