Meteor.startup ->
  Router.configure
    layoutTemplate: 'layout'

  Router.map ->
    @route 'fleetr', path: '/'
    @route 'driver'
    @route 'drivers'
    @route 'vehicle'
    @route 'vehicles'
    @route 'company'
    @route 'companies'
    @route 'fleet', path: '/fleet/:companyId', data: -> 
      data = { companyId : @params.companyId }
      return data;
   
