Template.checkboxCell.helpers
  checked: ->
    if @data.value then 'checked' else ''

Template.checkboxCell.events
  'change .active': (e, t) ->
    modifier = $set: {}
    modifier['$set'][@field] = e.target.checked
    Meteor.call @submitMethod, @data.rowObject, modifier
