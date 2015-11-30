Template.maintenance.events
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

  "click .btn-get-current" : (e) ->
     $("input[name='maintenanceDate']").val(moment())
     v = Vehicles.findOne(_id: @vehicleId)
     if v
       console.log v
       $("input[name='odometer']").val(parseInt(v.odometer))
       $("input[name='engineHours']").val(parseInt(v.engineHours))
