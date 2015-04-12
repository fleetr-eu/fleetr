Template.driverFilter.rendered = ->
  Session.set(@data.sessionVar, {selectedDriverId: undefined}) if @data.sessionVar
  @subscribe 'drivers'

Template.driverFilter.helpers
  drivers: -> Drivers.find {}, {sort: name: 1}

Template.driverFilter.events
  'change .driver-filter': (e, t) ->
    if @sessionVar
      Session.set @sessionVar,
        selectedDriverId: t.$('.driver-filter').val()
