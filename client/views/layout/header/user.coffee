Template.user.helpers
  userEmail: -> Meteor.user()?.emails[0].address
  pathForAdminBoard: -> AdminDashboard.path('/')
