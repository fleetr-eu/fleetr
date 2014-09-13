Meteor.subscribe 'books'

Template.updateBookForm.editingDoc = -> Books.findOne _id: Session.get('selectedDocId')

Template.bookList.books = -> Books.find()
Template.bookList.events
    'click .list-group-item': (e) ->
        Session.set('selectedDocId', this._id)
        $('li.list-group-item').removeClass('active')
        $(e.target).addClass('active')
    'click .deleteItem': -> Books.remove({_id: this._id})


