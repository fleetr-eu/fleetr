Template.map.created = -> Session.setDefault 'vehicleFilter', ''

Template.map.rendered = ->
  Meteor.typeahead.inject()
  Session.set 'selectedVehicleId', @data.vehicleId

  Map.init =>
    @autorun ->
      selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      if selectedVehicle
        if selectedVehicle.lat && selectedVehicle.lon
          Map.setCenter [selectedVehicle.lat, selectedVehicle.lon]
        else
          Alerts.set 'This vehicle has no known position.'

Template.map.helpers
  selectedVehicleId: -> Session.get('selectedVehicleId')
  renderMarkers: -> Map.renderMarkers()
  vehicles: ->
    [
      {
        name: 'vehicles'
        valueKey: ['name', 'licensePlate', 'tags']
        displayKey: 'displayName'
        local: -> Vehicles.find().fetch().map (it) ->
          _.extend it,
            displayName: "#{it.name} (#{it.licensePlate})"
            type: 'vehicle'
        header: '<h4 style="margin-left:5px;"><strong><i>Vehicles</i></strong></h4>'
        template: 'vehicleSuggestion'
      },
      {
        name: 'drivers'
        valueKey: ['name', 'firstName', 'tags']
        displayKey: 'displayName'
        local: -> Drivers.find().fetch().map (it) ->
          _.extend it,
            displayName: "#{it.firstName} #{it.name}"
            type: 'driver'
        header: '<h4 style="margin-left:5px;"><strong><i>Drivers</i></strong></h4>'
        template: 'driverSuggestion'
      }
    ]
  select: (event, suggestion, datasetName) ->
    switch suggestion.type # datasetName is not set
      when 'vehicle'
        Session.set 'selectedVehicleId', suggestion._id
      when 'driver'
        console.log 'TODO: display driver'
      when 'object'
        console.log 'TODO: display geofence'
      else
        console.log 'Hmm, I do not know how to display this?!'

Template.map.events
  'click #pac-input-clear': -> $('#pac-input').val('')
