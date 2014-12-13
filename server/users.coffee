Accounts.onLogin (opts) ->
  unless opts.user.group || opts.user.admin
    groupId = opts.methodArguments[0].user.email.split('@')[1] #use the email domain for groupId
    Partitioner.setUserGroup opts.user._id, groupId
