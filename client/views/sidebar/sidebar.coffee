Template.sidebar.helpers
    dashboardActive: ->
      console.log Session.get('activeCategory')
      if Session.get('activeCategory') == 'dashboard' 
        'active' 
      else
        ''
     fleetActive: ->
      console.log Session.get('activeCategory')
      if Session.get('activeCategory') == 'fleet' 
        'active' 
      else
        ''
    vehicleActive: ->
      console.log Session.get('activeCategory')
      if Session.get('activeCategory') == 'vehicle' 
        'active' 
      else
        ''
    driverActive: ->
      console.log Session.get('activeCategory')
      if Session.get('activeCategory') == 'driver' 
        'active' 
      else
        ''