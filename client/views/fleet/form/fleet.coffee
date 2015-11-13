Template.fleet.rendered = ->
  AutoForm.getValidationContext("fleetForm").resetValidation()

Template.fleet.events
  "click .submit" : (e) ->
    $("#fleetForm").submit()

AutoForm.hooks
  fleetForm:
    onSuccess: -> Modal.hide()
