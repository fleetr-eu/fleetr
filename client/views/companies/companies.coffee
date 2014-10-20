Template.companies.events
  'click .deleteCompany': -> Meteor.call 'removeCompany', @_id

Template.companies.helpers
  companies: ->
    filter =
      $regex: "#{Session.get('companyFilter').trim()}".replace ' ', '|'
      $options: 'i'
    Companies.find ({name: filter})
  
Template.companyNode.helpers    
  fleets: (companyId)->
    console.log(companyId)
    Fleets.find(parent : companyId)
  