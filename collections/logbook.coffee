@Logbook = new Meteor.Collection "logbook"

Logbook.after.insert (userId, e) -> 
	console.log 'HOOK!'
	console.log JSON.stringify(e)
	id = e.deviceId
	vehicle = Vehicles.findOne {unitId: id}

	# vehicle = @Vehicles.findOne {unitId:id}
	if not vehicle
		console.log 'No vehicle found for unit id: ' + id
		return

	console.log 'Vehicle: ' + JSON.stringify(vehicle)
	
	# if e.type == 30 # trackpoint
	# 	update = {lastUpdate: e.recordTime, speed: e.speed, lat: e.lat, lon: e.lon, odometer: e.tacho}
	# 	vehicle.update {_id: id}, {$set: update}	
	# 	console.log 'update vehile trackpoint status: ' + id + ' ' + JSON.stringify(update)
	# if e.type == 29 # start/stop
	# 	status = if e.io % 2 == 0 then 'stop' else 'start'
	# 	update = {lastUpdate: e.recordTime, speed: e.speed, lat: e.lat, lon: e.lon, odometer: e.tacho, status: status}
	# 	vehicle.update {_id: id}, {$set: update}	
	# 	console.log 'update vehile start/stop status: ' + id + ' ' + JSON.stringify(update)

