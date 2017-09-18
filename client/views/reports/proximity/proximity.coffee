placeLocation = undefined
location = new ReactiveVar {}
aggregators = [ new Slick.Data.Aggregators.Sum 'distance' ]

Template.proximity.onRendered ->
  Session.set 'proximity report location', null
  autocomplete = new google.maps.places.Autocomplete(
    document.getElementById('proximity-address')
    types: []
  )
  autocomplete.addListener('place_changed', ->
    place = autocomplete.getPlace();
    lat = do place.geometry.location.lat
    lng = do place.geometry.location.lng
    distance = $('#proximity-distance').val()
    address = place.formatted_address
    placeLocation =
      coords: [lng, lat]
      address: address
  )

Template.proximity.events
  'submit #proximity-location-form': (e, t) ->
    e.preventDefault()
    if placeLocation
      address = placeLocation.address
      location.set
        coords: placeLocation.coords
        address: placeLocation.address
        distance: parseFloat(t.$('#proximity-distance').val())
        restOnly: t.$('#rest-only').is(':checked')
      $('#proximity-address').val(address)

Template.proximity.helpers
  location: ->
    location.get()

Template.proximityGrid.onRendered ->
  @autorun ->
    loc = location.get()
    if loc.coords?.length is 2
      Session.set 'render proximity report', false
      Meteor.defer ->
        Session.set 'render proximity report', true

Template.proximityGrid.helpers
  render: ->
    Session.get 'render proximity report'
  fleetrGridConfig: ->
    columns: [
      id: "date"
      field: "date"
      name: TAPi18n.__('time.date')
      width: 20
      sortable: true
      search: where: 'client'
      groupable: true
    ,
      id: "time"
      field: "time"
      name: TAPi18n.__('time.time')
      width: 20
      sortable: true
      search: where: 'client'
    ,
      id: "vehicleName"
      field: "vehicleName"
      name: TAPi18n.__('vehicles.title')
      width: 50
      sortable: true
      search: where: 'client'
      groupable: true
    ,
      id: "tripId"
      field: "tripId"
      name: 'M'
      maxWidth: 31
      align: 'center'
      formatter: (row, cell, value, column, rowObject) ->
        {tripId, deviceId, date} = rowObject
        """
        <a href='/map/#{deviceId}/#{date}/#{tripId}'>
          <img src='/images/Google-Maps-icon.png' height='22'/>
        </a>
        """
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    remoteMethod: 'reports/proximity'
    remoteMethodParams: @location
    customize: (grid) ->
      grid.addGroupBy 'date', TAPi18n.__('time.date'), aggregators
