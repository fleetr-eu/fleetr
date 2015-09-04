Template.geofences.helpers
  selectedGeofenceId: -> Session.get('selectedGeofenceId')
  renderGeofences: -> renderGeofences()

Template.geofences.created = ->
  GeofenceMap.init -> renderGeofences()
  @autorun ->
    Meteor.subscribe 'geofences', Session.get('geofenceFilter')
  @autorun ->
    unless Session.get('addGeofence') || Session.get('editGeofence')
      GeofenceMap?.circle?.setMap(null)
      GeofenceMap?.circle = null
  @autorun ->
    if Session.get('addGeofence')
      GeofenceMap?.clear()
    else
      renderGeofences()
  @autorun ->
    if Session.get('editGeofence')
      GeofenceMap?.clear()
      renderGeofence Session.get('selectedGeofenceId')
    else
      renderGeofences()

renderGeofence = (id) ->
  geo = Geofences.findOne(_id: id)
  [lng, lat] = geo.center
  GeofenceMap.circle = GeofenceMap.drawCircle new google.maps.LatLng(lat, lng), geo.radius, {editable: true, id: geo._id}

renderGeofences = ->
  GeofenceMap?.clear()
  Geofences.find().forEach (geo) ->
    [lng, lat] = geo.center
    circle = GeofenceMap.drawCircle new google.maps.LatLng(lat, lng), geo.radius, {editable: false, id: geo._id}
    google.maps.event.addListener circle, 'click', -> Session.set 'selectedGeofenceId', geo._id

Template.geofences.events
  'click .addGeofence': ->
    Session.set 'selectedGeofenceId', null
    Session.set 'editGeofence', false
    Session.set 'addGeofence', true
  'click .editGeofence': ->
    Session.set 'addGeofence', false
    Session.set 'editGeofence', true
  'click .deleteGeofence': ->
    Meteor.call 'removeGeofence', Session.get('selectedGeofenceId')
    Session.set 'selectedGeofenceId', null

Template.editGeofence.helpers
  editGeofence: -> Session.get('addGeofence') || Session.get('editGeofence')
  doc: -> Geofences.findOne _id: Session.get('selectedGeofenceId')

Template.editGeofence.events
  'click .btn-sm': (e, template) ->
    circle = GeofenceMap.circle
    doc =
      name: template.$('#geofenceForm input[name=name]').val()
      tags: template.$('#geofenceForm input[name=tags]').val()
      center: [circle?.getCenter().lng(), circle?.getCenter().lat()]
      radius: circle?.getRadius()
    doc._id = Session.get('selectedGeofenceId') if Session.get('selectedGeofenceId')
    Meteor.call 'submitGeofence', doc
    Session.set 'addGeofence', false
    Session.set 'editGeofence', false
  'click .btn-reset' : (e) ->
    Session.set('addGeofence', false)
    Session.set('editGeofence', false)

Template.geofencesTable.helpers
  geofences: -> Geofences.find()

Template.geofencesTableRow.helpers
  active: -> if Session.equals('selectedGeofenceId', @_id) then 'active' else ''
  tagsArray: -> tagsAsArray.call @
Template.geofencesTableRow.events
  'click tr': ->
    Session.set 'selectedGeofenceId', @_id
    GeofenceMap?.setCenter(Geofences.findOne(_id: @_id).center)
