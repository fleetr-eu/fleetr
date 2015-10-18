Template.map.onCreated ->
  @showFilterBox = new ReactiveVar false

Template.map.onRendered ->
  Session.set 'selectedVehicleId', @data.vehicleId
  Map.init =>
    @autorun ->
      selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      if selectedVehicle
        if selectedVehicle.lat && selectedVehicle.lon
          Map.setCenter [selectedVehicle.lat, selectedVehicle.lon]
        else
          Alerts.set 'This vehicle has no known position.'

    @autorun -> Map.renderMarkers(); Session.get 'vehicleFilter'

Template.map.helpers
  filterOptions: -> vehicleDisplayStyle: 'list'
  selectedVehicleId: -> Session.get('selectedVehicleId')
  filterSize: -> if Template.instance().showFilterBox.get() then 'col-md-4' else 'hidden'
  mapSize: -> if Template.instance().showFilterBox.get() then 'col-md-8' else 'col-md-12'

Template.map.events
  'click #pac-input-clear': -> $('#pac-input').val('')
  'click #toggle-filter': (e, t) -> t.showFilterBox.set not t.showFilterBox.get()
