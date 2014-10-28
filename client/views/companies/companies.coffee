Template.companies.events
  'click .deleteCompany': -> Meteor.call 'removeCompany', @_id
  'keyup input.search-query': -> 
      Session.set 'filterFleets', $('#filterFleets').val()

Template.companies.helpers
  companies: ->
    Companies.find ({})
      
Template.companyNode.helpers    
  fleets: (companyId)->
    filter =
      $regex: "#{Session.get('filterFleets').trim()}".replace ' ', '|'
      $options: 'i'
    Fleets.find {parent: companyId, name: filter}
