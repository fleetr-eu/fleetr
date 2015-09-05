Template.filter.onRendered ->
  @autorun =>
    Template.instance().$('input#filter').val Session.set(@sessionVar)

Template.filter.events
  'input #filter': (e, tpl) -> Session.set @sessionVar, tpl.$('#filter').val()
  'click #clearFilter': -> Session.set @sessionVar, ''

Template.filter.helpers
  _value: -> Session.get @sessionVar
