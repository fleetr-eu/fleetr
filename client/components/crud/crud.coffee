Meteor.startup ->
  Template.crud.onRendered ->
    Session.set 'selectedItemId', null

  Template.crud.helpers
    selectedItemId: -> Session.get('selectedItemId')
    gridConfig: -> Template.instance().data.gridConfig
    title: -> "#{Template.instance().data.i18nRoot}.listTitle"

  Template.crud.events
    'click .delete-item': (e, t) ->
      Modal.show 'confirmDelete',
        title: -> "#{t.data.i18nRoot}.title"
        message: -> "#{t.data.i18nRoot}.deleteMessage"
        action: ->
          Meteor.call t.data.removeItemMethod, Session.get('selectedItemId'), ->
            Meteor.defer ->
              Session.set 'selectedItemId', t.grid.data[t.row]?._id
    'rowsSelected': (e, t) ->
      unless e.rowIndex is -1
        [t.grid, t.row] = [e.fleetrGrid, e.rowIndex]
        Session.set 'selectedItemId', t.grid.data[t.row]._id
      else Session.set 'selectedItemId', null
    'click .edit-item': (e, t) ->
      ModalForm.show t.data.editItemTemplate,
        title: -> "#{t.data.i18nRoot}.title"
        data:
          doc: -> t.data.collection.findOne(_id: Session.get('selectedItemId'))
    'click .add-item': (e, t) ->
      ModalForm.show t.data.editItemTemplate,
        title: -> "#{t.data.i18nRoot}.title"
        data: {}
