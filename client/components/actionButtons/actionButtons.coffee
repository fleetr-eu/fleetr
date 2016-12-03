Meteor.startup ->
  Template.actionButtons.onRendered ->
    Session.set 'selectedItemId', null

  Template.actionButtons.helpers
    selectedItemId: -> Session.get('selectedItemId')
    show: ->
      add: if @buttons?.add is undefined then true else @buttons.add
      edit: if @buttons?.edit is undefined then true else @buttons.edit
      delete: if @buttons?.delete is undefined then true else @buttons.delete

  Template.actionButtons.events
    'click .delete-item': (e, t) ->
      Modal.show 'confirmDelete',
        title: => "#{@i18nRoot}.title"
        message: => "#{@i18nRoot}.deleteMessage"
        action: =>
          Meteor.call @removeItemMethod, Session.get('selectedItemId')
    'click .edit-item': (e, t) ->
      ModalForm.show @editItemTemplate,
        title: => "#{@i18nRoot}.title"
        data:
          doc: => @collection.findOne(_id: Session.get('selectedItemId'))
    'click .add-item': (e, t) ->
      ModalForm.show @editItemTemplate,
        title: => "#{@i18nRoot}.title"
        data: {}
