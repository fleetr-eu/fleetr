Template.geofences.helpers
  selectedGeofence: getSelectedGf = ->
    Geofences.findOne(Session.get('selectedGeofenceId'))
  selectedGeofenceId: -> Session.get('selectedGeofenceId')
  selectedGeofenceName: -> getSelectedGf()?.name
  renderGeofences: -> renderGeofences()
  showGfList: -> Session.get 'showGfList'
  inEditMode: -> Session.get('addGeofence') || Session.get('editGeofence')

Template.geofences.onRendered ->
  GeofenceMap.init -> renderGeofences getSelectedGf()?.center
  @autorun ->
    Meteor.subscribe 'geofences'
  @autorun ->
    if Session.get('editGeofence')
      renderGeofence Session.get('selectedGeofenceId')
    else
      GeofenceMap?.circle?.setMap(null)
      GeofenceMap?.circle = null

renderGeofence = (id) ->
  geo = Geofences.findOne(_id: id)
  [lng, lat] = geo.center
  GeofenceMap.circle = GeofenceMap.drawCircle new google.maps.LatLng(lat, lng), geo.radius, {editable: true, id: geo._id}

renderGeofences = (center) ->
  GeofenceMap?.clear()
  Geofences.find().forEach (geo) ->
    [lng, lat] = geo.center
    strokeWeight = if geo._id is Session.get('selectedGeofenceId') then 8 else 2
    circle = GeofenceMap.drawCircle new google.maps.LatLng(lat, lng), geo.radius,
      editable: false
      id: geo._id
      strokeWeight: strokeWeight
    google.maps.event.addListener circle, 'click', ->
      Session.set 'selectedGeofenceId', geo._id
    GeofenceMap?.setCenter center if center

Template.geofences.events
  'click #pac-input-clear': -> $('#pac-input').val('')
  'click #toggle-filter': ->
    Session.set 'showGfList', not Session.get('showGfList')
  'click .addGeofence': ->
    Session.set 'selectedGeofenceId', null
    Session.set 'editGeofence', false
    Session.set 'addGeofence', true
    Session.set 'showGfList', true
  'click .editGeofence': ->
    Session.set 'addGeofence', false
    Session.set 'editGeofence', true
    Session.set 'showGfList', true
  'click .deleteGeofence': ->
    Modal.show 'confirmDelete',
      title: 'geofences.title'
      message: 'geofences.deleteMessage'
      action: ->
        Meteor.call 'removeGeofence', Session.get('selectedGeofenceId')
        Session.set 'selectedGeofenceId', null

Template.editGeofence.events
  'click .btn-submit': (e, template) ->
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
    renderGeofences()

Template.geofencesTable.helpers
  geofences: -> Geofences.find()

Template.geofencesTableRow.helpers
  active: -> if Session.equals('selectedGeofenceId', @_id) then 'active' else ''
  tagsArray: -> tagsAsArray.call @
Template.geofencesTableRow.events
  'click tr': ->
    Session.set 'selectedGeofenceId', @_id
    GeofenceMap?.setCenter(Geofences.findOne(_id: @_id)?.center)
