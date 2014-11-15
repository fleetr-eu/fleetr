Template.fleetGroups.created = ->
  Session.setDefault 'groups.expandedGroups', _.pluck(FleetGroups.find().fetch(), '_id')

Template.fleetGroups.events
  'click .deleteGroup': -> Meteor.call 'removeFleetGroup', @_id
  'click .group': -> Session.set 'groups.selectedGroupId', @_id
  'click .excol-group': (e, tpl) ->
    groups = Session.get 'groups.expandedGroups'
    if @_id in groups
      groups = groups.filter (id) => id isnt @_id
    else
      groups.push @_id
    Session.set 'groups.expandedGroups', groups

Template.fleetGroups.helpers
  fleetGroups: -> FleetGroups.find {}, {$sort: {name: 1}}
  fleets: ->
    Fleets.find $and: [{parent: @_id}, {parent: {$in: Session.get('groups.expandedGroups')}}]
  fleetCount: -> Fleets.find(parent: @_id).count()
  excolIcon: -> if @_id in Session.get('groups.expandedGroups') then 'minus' else 'plus'

Template.fleetsPerGroup.events
  'click .deleteFleet': -> Meteor.call 'removeFleet', @_id
  'click .fleet': -> Session.set 'groups.selectedFleetId', @_id

Template.detailsForm.helpers
  editingGroup: -> FleetGroups.findOne _id: Session.get('groups.selectedGroupId')

Template.detailsForm.events
  'click .reset': -> Session.set 'groups.selectedGroupId', null

Template.fleetForm.helpers
  editingFleet: -> Fleets.findOne _id: Session.get('groups.selectedFleetId')
  fleetSchema: -> Schema.fleet

Template.fleetForm.events
  'click .reset': -> Session.set 'groups.selectedFleetId', null
