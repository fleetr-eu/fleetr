@Locations = new Mongo.Collection 'locations'

Locations.before.insert (userId, doc) ->
  doc.timestamp ?= Date.now()
  Vehicles.update {_id: doc.vehicleId}, {$set: {lastLocation: doc}}
  
Locations.findForVehicles = (vehicleIds) ->
    Locations.find {vehicleId: {$in: vehicleIds}}, {sort: {timestamp: -1}}

Locations.utils =

  logLocation: ->
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition(Locations.utils.saveLocation)

  saveLocation: (pos)->
    if Session.get("loggedVehicle")
      newLocation = [pos.coords.longitude, pos.coords.latitude]
      lastLocation = Locations.findOne {vehicleId: Session.get("loggedVehicle")}, {sort: {timestamp: -1}}
      if lastLocation
        if (lastLocation.loc[0] != newLocation[0]) or (lastLocation.loc[1] != newLocation[1])
          Meteor.call 'addLocation', {
            loc: newLocation,
            speed: 50,
            stay: 0,
            vehicleId: Session.get("loggedVehicle")
          }
          console.log "move: " + newLocation
        else
          stay = Math.round(moment().diff(lastLocation.timestamp)/1000)
          Meteor.call 'updateLocation', lastLocation._id, stay
          console.log "stay: " + stay
      else
        Meteor.call 'addLocation', {
          loc: newLocation,
          speed: 50,
          stay: 0,
          vehicleId: Session.get("loggedVehicle")
        }
        console.log "start loggin: "+Session.get("loggedVehicle")
