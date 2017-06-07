TripMapWithInfo = require '/imports/ui/fleetr-maps/TripMapWithInfo.cjsx'


unitId = null
Template.simpleMap.onCreated ->
  Session.set 'simpleMapShowInfoMarkers', false

Template.simpleMap.onRendered ->
  return
  {deviceId, tripId, start, stop, idle, addressLoc, address} = @data.parsed
  @map = FleetrMap.currentMap().map

  if addressLoc?.length is 2
    addressLatLng = {lat: addressLoc[1], lng: addressLoc[0]}
    marker = new google.maps.Marker
      position: addressLatLng
      map: @map
      icon: '/images/address.png'

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
      start.time = moment(start.time).toDate() if start.time
      stop.time = moment(stop.time).toDate() if stop.time
      recordTime:
        $gte: start.time
        $lte: stop.time
      deviceId: deviceId

    bounds = new google.maps.LatLngBounds()
    Meteor.subscribe 'logbook', searchArgs, =>

      @path = Logbook.find(searchArgs, {sort: recordTime: 1}).map (point) ->
        bounds.extend new google.maps.LatLng(point.lat, point.lng)
        _.pick point, 'lat', 'lng', 'speed', 'odometer', 'recordTime', 'address'
      @map.fitBounds bounds

      [start, ..., stop] = @path
      [_.extend({}, start, {title: 'Start', icon: '/images/icons/start.png'}),
      _.extend({}, stop, {title: 'Stop', icon: '/images/icons/finish.png'})].forEach (point) =>
        position =
          lat: point.lat
          lng: point.lng
        marker = _.extend({position: position}, point, {map: @map})
        new google.maps.Marker marker
      FleetrMap.currentMap().renderPath @path

formatTime = (time) ->
  moment(time).format('DD/MM/YYYY, HH:mm:ss')

Template.simpleMap.helpers
  TripMapWithInfo: -> TripMapWithInfo
  data: data = ->
    Template.instance().data.parsed
  vehicle: ->
    Vehicles.findOne unitId: data().deviceId
  startTime: ->
    formatTime data().start.time
  stopTime: ->
    formatTime data().stop.time
