@PermissionsManager =
  augment: (filter, subject, field = '_id') ->
    permissions = Permissions.findOne userId: Meteor.userId()
    if permissions?[subject]?.allow or permissions?[subject]?.deny
      modifier = []
      if permissions[subject]?.allow
        allowModifier = {}; allowModifier[field] = $in: permissions[subject].allow
        modifier.push allowModifier
      if permissions[subject]?.deny
        denyModifier = {}; denyModifier[field] = $nin: permissions[subject].deny
        modifier.push denyModifier
      lodash.merge filter, $and: modifier
    else
      filter

findUserByEmail = (email) ->
  Meteor.users.findOne
    emails:
      $elemMatch:
        address: email

Meteor.startup ->
  for email in AdminConfig.adminEmails
    user = findUserByEmail email
    Roles.addUsersToRoles user._id, ['editor'], Roles.GLOBAL_GROUP if user
