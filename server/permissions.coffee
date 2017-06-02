hasValue = (item) -> item isnt null and item isnt undefined

@PermissionsManager =
  modifiers: (subjects, field = '_id') ->
    permissions = Permissions.findOne userId: Meteor.userId()

    if permissions
      allowModifiers = for subject, field of subjects
        if permissions?.allow?[subject]
          "#{field}": $in: permissions?.allow[subject]
      allowModifiers = allowModifiers.filter hasValue
      allowModifier = if allowModifiers?.length
        $or: allowModifiers
      else {}

      denyModifiers = for subject, field of subjects
        if permissions?.deny?[subject]
          "#{field}": $nin: permissions?.deny[subject]
      denyModifiers = denyModifiers.filter hasValue
      denyModifier = if denyModifiers?.length
        $and: denyModifiers
      else {}

      $and: [allowModifier, denyModifier]
    else {}

findUserByEmail = (email) ->
  Meteor.users.findOne
    emails:
      $elemMatch:
        address: email

Meteor.startup ->
  for email in AdminConfig.adminEmails
    user = findUserByEmail email
    Roles.addUsersToRoles user._id, ['editor'], Roles.GLOBAL_GROUP if user
