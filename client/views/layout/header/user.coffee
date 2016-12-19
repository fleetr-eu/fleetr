Template.user.helpers
  userEmail: userEmail = -> Meteor.user()?.emails[0].address
  pathForAdminBoard: -> AdminDashboard.path('/')
  gravatar: ->
    if email = userEmail()
      Gravatar.imageUrl email,
        size: 34,
        default: 'mm'
