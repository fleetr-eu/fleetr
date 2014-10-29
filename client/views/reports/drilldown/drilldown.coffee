Template.drilldownReport.rendered = -> @$("#fleets").treetable()

Template.drilldownReport.helpers
  groups: -> Companies.find()

Template.fleetRows.helpers
  fleets: -> Fleets.find parent: @_id
