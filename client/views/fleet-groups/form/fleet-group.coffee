Template.fleetGroup.helpers
  fleetGroup: ->
    fg = FleetGroups.findOne _id: @groupId
    
Template.fleetGroup.events
  "click .btn-sm" : (e) ->
    $("#fleetGroupForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("fleetGroupForm")
