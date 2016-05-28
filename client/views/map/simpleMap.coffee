unitId = null
Template.simpleMap.onCreated ->
  Session.set 'simpleMapShowInfoMarkers', false

Template.simpleMap.onRendered ->
  {deviceId, tripId, start, stop, idle} =  EJSON.parse decodeURIComponent @data
  start.time = moment(start.time).toDate()
  stop.time = moment(stop.time).toDate()

  @map = FleetrMap.currentMap().map

  if idle
    Meteor.subscribe 'idlebook', searchArgs, ->
      idleRec = IdleBook.findOne searchArgs
      if idleRec
        lat = idleRec.latitude || idleRec.lat || idleRec.location?.latitude
        lng = idleRec.longitude || idleRec.lng || idleRec.location?.longitude
        pos = new google.maps.LatLng(lat, lng)
        @map.panTo pos
        new google.maps.Marker
          map: @map
          position: pos
          icon: '/images/truck-blue.png'
  else
    searchArgs = if tripId
      'attributes.trip': tripId
    else
      recordTime:
        $gte: start.time
        $lte: stop.time
      deviceId: deviceId

    bounds = new google.maps.LatLngBounds()
    Meteor.subscribe 'logbook', searchArgs, =>
      @path = Logbook.find(searchArgs, {sort: recordTime: 1}).map (point) ->
        _.pick point, 'lat', 'lng', 'speed', 'odometer', 'time'
      [start, ..., stop] = @path
      [_.extend(start, {title: 'Start', icon: '/images/icons/start.png'}),
      _.extend(stop, {title: 'Stop', icon: '/images/icons/finish.png'})].forEach (point) =>
        new google.maps.Marker _.extend(point, {map: @map})
        bounds.extend new google.maps.LatLng(point.lat, point.lng)
      @map.fitBounds bounds
      FleetrMap.currentMap().renderPath @path

Template.simpleMap.helpers
  vehicle: ->
    data = JSON.parse Template.instance().data
    Vehicles.findOne unitId: data.deviceId
