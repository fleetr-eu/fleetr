Template.fleet.rendered = ->
  AutoForm.resetForm("fleetForm")

Template.fleet.helpers
  fleet: -> Fleets.findOne _id: @fleetId

Template.fleet.events
  "click .btn-sm" : (e) ->
    $("#fleetForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("fleetForm")
