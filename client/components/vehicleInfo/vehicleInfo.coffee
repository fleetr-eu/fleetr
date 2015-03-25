unitId = ''

Template.vehicleInfo.created = ->
  unitId = @data.unitId

Template.vehicleInfo.helpers
  vehicle: ->
    Vehicles.findOne(unitId: unitId)
