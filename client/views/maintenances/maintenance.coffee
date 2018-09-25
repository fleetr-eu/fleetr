Template.maintenance.events
  "click .btn-calculate-next" : (e) ->
    mt = MaintenanceTypes.findOne _id:$("select[name='maintenanceType']").val()
    if mt
      if $("input[name='maintenanceDate']").val()
        if mt.nextMaintenanceMonths
          nmd = moment($("input[name='maintenanceDate']").val(), Settings.dpOptions.format).add(mt.nextMaintenanceMonths, "months")
          $("input[name='nextMaintenanceDate']").val(nmd.format(Settings.dpOptions.format))
      if $("input[name='odometer']").val()
        if mt.nextMaintenanceKMs
          nmo = parseInt($("input[name='odometer']").val()) + mt.nextMaintenanceKMs
          $("input[name='nextMaintenanceOdometer']").val(nmo)

      if $("input[name='engineHours']").val()
        if mt.nextMaintenanceEngineHours
          nmeo = parseInt($("input[name='engineHours']").val()) + mt.nextMaintenanceEngineHours
          $("input[name='nextMaintenanceEngineHours']").val(nmeo)

  "click .btn-get-current" : (e) ->
     $("input[name='maintenanceDate']").val(moment().format(Settings.dpOptions.format))
     v = Vehicles.findOne _id: Template.instance().vehicleId
     if v
       $("input[name='odometer']").val(Math.round(parseInt(v.odometer) / 1000))
       $("input[name='engineHours']").val(parseInt(v.engineHours))
