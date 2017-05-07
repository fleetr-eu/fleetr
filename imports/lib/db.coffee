doIfInRoles = (roles, cb) ->
  if Roles.userIsInRole Meteor.user(), roles
    cb?()
  else
    if Meteor.isClient
      sAlert.error
        sAlertIcon: 'exclamation'
        sAlertTitle: TAPi18n.__ 'alerts.error.title'
        message: TAPi18n.__ 'alerts.unauthorized.message'
    else
      throw new Meteor.Error TAPi18n.__('alerts.unauthorized.message')

doIfEditor = (cb) -> doIfInRoles ['editor'], cb

module.exports =
  doIfEditor: doIfEditor
  submitItem: (collection) -> (doc, id) ->
    @unblock()
    doIfEditor ->
      collection.submit doc, id

  removeItem: (collection) -> (doc) ->
    @unblock()
    doIfEditor ->
      collection.remove _id: doc
