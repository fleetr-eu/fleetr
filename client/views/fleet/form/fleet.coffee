Template.fleet.rendered = ->
  AutoForm.getValidationContext("fleetForm").resetValidation()

Template.fleet.helpers
  fleet: -> Fleets.findOne _id: @fleetId

Template.fleet.events
  "click .submit" : (e) ->
    $("#fleetForm").submit()
  "click .reset" : (e) ->
    AutoForm.resetForm("fleetForm")
