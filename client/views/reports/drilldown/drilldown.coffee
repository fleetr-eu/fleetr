Template.drilldownReport.created = ->
  Session.setDefault 'drilldownReport.includedGroups', _.pluck(FleetGroups.find().fetch(), '_id')

Template.drilldownReport.helpers
  groups: -> FleetGroups.find()

Template.fleetRows.helpers
  fleets: ->
    Fleets.find $and: [{parent: @_id}, {parent: {$in: Session.get('drilldownReport.includedGroups')}}]

Template.groupRow.events
  'click .excol-group': (e, tpl) ->
    groups = Session.get 'drilldownReport.includedGroups'
    if @_id in groups
      groups = groups.filter (id) => id isnt @_id
    else
      groups.push @_id
    Session.set 'drilldownReport.includedGroups', groups

Template.groupRow.helpers
  excolIcon: -> if @_id in Session.get('drilldownReport.includedGroups') then 'caret-down' else 'caret-right'
