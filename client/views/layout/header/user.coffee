Template.user.helpers
  userEmail: userEmail = -> Meteor.user()?.emails[0].address
  pathForAdminBoard: -> AdminDashboard.path('/')
  gravatar: ->
    Gravatar.imageUrl userEmail(),
      size: 34,
      default: 'mm'
