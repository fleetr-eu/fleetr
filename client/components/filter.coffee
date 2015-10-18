Template.filter.events
  'input #filter': (e, tpl) -> Session.set @sessionVar, e.target.value
  'click #clearFilter': -> Session.set @sessionVar, ''

Template.filter.helpers
  _value: -> Session.get @sessionVar
