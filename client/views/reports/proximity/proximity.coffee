location = new ReactiveVar {}
aggregators = [ new Slick.Data.Aggregators.Sum 'distance' ]

Template.proximity.onRendered ->
  Session.set 'proximity report location', null

Template.proximity.events
  'submit #proximity-location-form': (e, t) ->
    e.preventDefault()
    address = t.$('#proximity-address').val()
    distance = t.$('#proximity-distance').val()
    unless distance
      distance = 200
      t.$('#proximity-distance').val distance
    HTTP.get "http://nominatim.openstreetmap.org/search/#{address}",
      params:
        format: 'json'
        'accept-language': 'bg'
    , (err, result) ->
      {lat, lon} = result.data[0]
      console.log lat, lon, distance
      location.set
        coords: [parseFloat(lon), parseFloat(lat)]
        distance: parseFloat(distance)
      Session.set 'proximity report location', result.data[0].display_name

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
  locationDisplayName: ->
    Session.get 'proximity report location'
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
      formatter: (row, cell, value) ->
        q = encodeURIComponent EJSON.stringify
          tripId: value
        """
        <a href='/map/#{q}'>
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
