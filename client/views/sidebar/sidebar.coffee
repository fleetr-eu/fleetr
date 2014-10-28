Template.sidebar.helpers
    dashboardActive: ->
      if Session.get('activeCategory') == 'dashboard' 
        'active' 
      else
        ''
     fleetActive: ->
      if Session.get('activeCategory') == 'fleet' 
        'active' 
      else
        ''
    vehicleActive: ->
      if Session.get('activeCategory') == 'vehicle' 
        'active' 
      else
        ''
    driverActive: ->
      if Session.get('activeCategory') == 'driver' 
        'active' 
      else
        ''