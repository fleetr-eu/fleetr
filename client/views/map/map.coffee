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
  vehicles: -> Vehicles.find().fetch().map (v) ->
    value: "#{v.name} (#{v.licensePlate}) | #{v.tags.join(', ')}"
    id: v._id
  selectVehicle: (event, suggestion, datasetName) ->
    Session.set 'selectedVehicleId', suggestion.id

Template.map.events
  'click #pac-input-clear': -> $('#pac-input').val('')
