Template.fleet.rendered = ->
  AutoForm.getValidationContext("fleetForm").resetValidation()

Template.fleet.events
  "click .submit" : (e, t) -> t.$("#fleetForm").submit()
  'shown.bs.modal #editFleet': (e, t) -> t.$('#fleetForm input').focus()

AutoForm.hooks
  fleetForm: onSuccess: -> Modal.hide()
