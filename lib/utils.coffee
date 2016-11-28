@isBusinessTrip = (vehicle, recTime) ->
  time = moment(recTime).format("hh:mm a")
  dow = moment(recTime).day()
  from = vehicle.workHours && vehicle.workHours[dow] && vehicle.workHours[dow].from
  to = vehicle.workHours && vehicle.workHours[dow] && vehicle.workHours[dow].to
  console.log(from+", "+to)
  true
