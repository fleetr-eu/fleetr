Template.maintenance.helpers
  vehicleName: ->
    v = Vehicles.findOne _id: @vehicleId
    "#{v?.name} (#{v?.licensePlate})"

Template.maintenance.events
  "click .btn-sm" : (e) ->
    $("#maintenancesForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("maintenancesForm")
  "click .btn-calculate-next" : (e) ->
    mt = MaintenanceTypes.findOne _id:$("select[name='maintenanceType']").val()
    if mt
      if $("input[name='maintenanceDate']").val()
        if mt.nextMaintenanceMonths
          nmd = moment($("input[name='maintenanceDate']").val()).add(mt.nextMaintenanceMonths, "months")
          $("input[name='nextMaintenanceDate']").val(nmd)

      if $("input[name='odometer']").val()
        if mt.nextMaintenanceKMs
          nmo = parseInt($("input[name='odometer']").val()) + mt.nextMaintenanceKMs
          $("input[name='nextMaintenanceOdometer']").val(nmo)

      if $("input[name='engineHours']").val()
        if mt.nextMaintenanceEngineHours
          nmeo = parseInt($("input[name='engineHours']").val()) + mt.nextMaintenanceEngineHours
          $("input[name='nextMaintenanceEngineHours']").val(nmeo)
