Template.fleet.rendered = ->
  AutoForm.getValidationContext("fleetForm").resetValidation()

Template.fleet.events
  "modal-submit": (e, t) -> t.$("#fleetForm").submit()

AutoForm.hooks
  fleetForm: onSuccess: -> Modal.hide()
