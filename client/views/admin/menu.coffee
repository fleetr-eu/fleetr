Meteor.startup ->
  AdminDashboard.addSidebarItem('Roles', AdminDashboard.path('/roles'), { icon: 'key' })

  Router.route 'roles',
    path: AdminDashboard.path 'roles'
    controller: 'AdminController'
    onAfterAction: ->
      Session.set 'admin_title', 'Roles'
