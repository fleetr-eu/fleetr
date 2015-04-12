Template.combiFilter.rendered = ->
  Session.set(@data.sessionVar, {activeFilter: 'vehicle'}) if @data.sessionVar
  @autorun =>
    vehicleFilter = Session.get "combi filter session var vehicle"
    driverFilter = Session.get "combi filter session var driver"
    combiFilter = _.extend(vehicleFilter, driverFilter) || {}
    if @data.sessionVar
      Session.set @data.sessionVar, _.extend(combiFilter, Session.get(@data.sessionVar))

Template.combiFilter.events
  'click ul.nav-tabs a': (e, t) ->
    combiFilter = Session.get @sessionVar || {}
    combiFilter.activeFilter = e.target.getAttribute('value')
    Session.set @sessionVar, combiFilter
