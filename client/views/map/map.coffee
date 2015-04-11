Template.map.rendered = ->
  Session.set "mapDateRangeFrom", +moment().subtract(2, "hours").format("X")
  Session.set "mapDateRangeTo", +moment().add(1, "hours").format("X")
  Session.set 'selectedVehicleId', @data.vehicleId

  Map.init =>
    @autorun ->
      vehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      if vehicle
        Meteor.subscribe 'logbook',
          deviceId: vehicle.unitId
          recordTime:
            $gte: Session.get("mapDateRangeFrom") * 1000
            $lte: Session.get("mapDateRangeTo") * 1000
        , Map.renderMarkers

  $("#hours_range").ionRangeSlider
    type : "double"
    min: +moment().subtract(24, "hours").format("X")
    max: +moment().add(2, "hours").format("X")
    from: +moment().subtract(2, "hours").format("X")
    to: +moment().add(1, "hours").format("X")
    grid: true
    keyboard: true
    keyboard_step: 1
    force_edges: true
    prettify: (num) ->
        m = moment(num, "X")
        m.locale(Settings.locale).format("Do MMMM, HH:mm")
    onChange: (data) ->
      Session.set "mapDateRangeFrom", data.from
      Session.set "mapDateRangeTo", data.to


Template.map.helpers
  selectedVehicleId: -> Session.get('selectedVehicleId')
  renderMarkers: -> Map.renderMarkers()

Template.map.created = -> Session.setDefault 'vehicleFilter', ''

Template.vehiclesMapTable.helpers
  vehicles: -> Vehicles.findFiltered 'vehicleFilter', ['licensePlate', 'tags']

Template.vehicleMapTableRow.helpers
  fleetName: -> Fleets.findOne(_id : @allocatedToFleet).name
  active: -> if @_id == Session.get('selectedVehicleId') then 'active' else ''
  allocatedToFleetFromDate: -> @allocatedToFleetFromDate.toLocaleDateString()
  tagsArray: -> tagsAsArray.call @

Template.vehicleMapTableRow.events
  'click tr': -> Session.set 'selectedVehicleId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#vehicles #filter').val(tag)
    Session.set 'vehicleFilter', tag

Template.map.events
  'click #pac-input-clear': ->
    $('#pac-input').val('')
