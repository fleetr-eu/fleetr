Template.checkboxCell.helpers
  checked: ->
    if @data.value then 'checked' else ''

Template.checkboxCell.events
  'change .active': (e, t) ->
    modifier = $set: @data.rowObject
    modifier['$set'][@field] = e.target.checked
    Meteor.call @submitMethod, modifier, @data.rowObject._id
