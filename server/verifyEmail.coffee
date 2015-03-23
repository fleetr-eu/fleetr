Meteor.startup ->
  Accounts.validateLoginAttempt (info) ->
    console.log info
