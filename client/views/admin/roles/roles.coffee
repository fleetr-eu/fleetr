Template.roles.helpers
  users: -> Meteor.users.find()
  groups: ->
    if @roles
      group: g, roles: r for g, r of @roles
    else []
  email: ->
    @emails[0]?.address or ''
