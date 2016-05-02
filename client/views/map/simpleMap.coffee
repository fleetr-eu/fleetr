unitId = null
Template.simpleMap.onCreated ->
  Session.set 'simpleMapShowInfoMarkers', false

Template.simpleMap.onRendered ->
  {deviceId, tripId, start, stop, idle} =  EJSON.parse decodeURIComponent @data
  start.time = moment(start.time).toDate()
  stop.time = moment(stop.time).toDate()

  @map = FleetrMap.currentMap().map

  if idle
    searchArgs =
      startTime: start.time
      stopTime: stop.time
      deviceId: deviceId
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
    bounds = new google.maps.LatLngBounds()
    [_.extend(start, {title: 'Start', icon: '/images/icons/start.png'}),
    _.extend(stop, {title: 'Stop', icon: '/images/icons/finish.png'})].forEach (point) =>
      new google.maps.Marker _.extend(point, {map: @map})
      bounds.extend new google.maps.LatLng(point.position.lat, point.position.lng)
    @map.fitBounds bounds

    searchArgs =
      'attributes.trip': tripId

    Meteor.subscribe 'logbook', searchArgs, =>
      @path = Logbook.find(searchArgs, {sort: recordTime: 1}).map (point) ->
        point.odometer = point.tacho
        _.pick point, 'lat', 'lng', 'speed', 'odometer', 'time'
      FleetrMap.currentMap().renderPath @path
