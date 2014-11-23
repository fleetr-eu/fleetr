Template.geofences.helpers
  selectedGeofenceId: -> Session.get('selectedGeofenceId')
  renderGeofences: ->
    # GeofenceMap?.clear()
    Geofences.find().forEach (geo) ->
      [lng, lat] = geo.center
      circle = GeofenceMap.drawCircle new google.maps.LatLng(lat, lng), geo.radius, {editable: false, id: geo._id}
      google.maps.event.addListener circle, 'click', -> Session.set 'selectedGeofenceId', geo._id

Template.geofences.created = ->
  GeofenceMap.init ->
    console.log 'map rendered'
  @autorun ->
    unless Session.get('addGeofence') || Session.get('editGeofence')
      GeofenceMap?.circle?.setMap(null)

Template.geofences.events
  'click .addGeofence': -> Session.set 'addGeofence', true

Template.editGeofence.helpers
  editGeofence: -> Session.get('addGeofence') || Session.get('editGeofence')

Template.editGeofence.events
  'click .geofence-cancel': ->
    Session.set('addGeofence', false)
    Session.get('editGeofence', false)
  'click .geofence-submit': (e, template) ->
    Session.set 'addGeofence', false
    circle = GeofenceMap.circle
    Meteor.call 'addGeofence',
      name: template.$('#geofence-name').val()
      center: [circle?.getCenter().lng(), circle?.getCenter().lat()]
      radius: circle?.getRadius()
      tags: template.$('#geofence-tags').val()

Template.geofencesTable.created = ->
  Meteor.subscribe 'geofences'

Template.geofencesTable.helpers
  geofences: -> Geofences.find()

Template.geofencesTableRow.helpers
  active: -> if Session.equals('selectedGeofenceId', @_id) then 'active' else ''
  tagsArray: -> tagsAsArray.call @
Template.geofencesTableRow.events
  'click tr': ->
    Session.set 'selectedGeofenceId', @_id
    GeofenceMap?.setCenter(Geofences.findOne(_id: @_id).center)
