Meteor.startup ->
  Template.crud.helpers
    selectedItemId: -> Session.get('selectedItemId')
    gridConfig: -> @gridConfig
    title: -> "#{@i18nRoot}.listTitle"
