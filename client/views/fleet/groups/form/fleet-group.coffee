Template.fleetGroup.rendered = ->
  AutoForm.getValidationContext("fleetGroupForm").resetValidation()

Template.fleetGroup.helpers
  fleetGroup: -> FleetGroups.findOne _id: @fleetGroupId

Template.fleetGroup.events
  "click .submit" : (e) ->
    $("#fleetGroupForm").submit()
  "click .reset" : (e) ->
    AutoForm.resetForm("fleetGroupForm")
