Template.companies.created = ->
  Session.setDefault 'companies.includedGroups', _.pluck(Companies.find().fetch(), '_id')

Template.companies.events
  'click .deleteCompany': -> Meteor.call 'removeCompany', @_id
  'click .group': -> Session.set 'companies.selectedGroupId', @_id
  'click .excol-group': (e, tpl) ->
    groups = Session.get 'companies.includedGroups'
    if @_id in groups
      groups = groups.filter (id) => id isnt @_id
    else
      groups.push @_id
    Session.set 'companies.includedGroups', groups

Template.companies.helpers
  companies: -> Companies.find()
  fleets: ->
    Fleets.find $and: [{parent: @_id}, {parent: {$in: Session.get('companies.includedGroups')}}]
  fleetCount: -> Fleets.find(parent: @_id).count()
  excolIcon: -> if @_id in Session.get('companies.includedGroups') then 'minus' else 'plus'
  editingGroup: -> Companies.findOne _id: Session.get('companies.selectedGroupId')

Template.detailsForm.helpers
  companySchema: -> Schema.company
