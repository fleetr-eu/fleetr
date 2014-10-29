Template.drilldownReport.rendered = -> @$("#fleets").treetable(expandable: true)

Template.drilldownReport.helpers
  groups: -> Companies.find()

Template.fleetRows.helpers
  fleets: -> Fleets.find parent: @_id
