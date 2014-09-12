Books = new Meteor.Collection("books");
Books.attachSchema(new SimpleSchema({
    title: {
        type: String,
        label: "Title",
        max: 200
    },
    author: {
        type: String,
        label: "Author"
    },
    copies: {
        type: Number,
        label: "Number of copies",
        min: 0
    },
    lastCheckedOut: {
        type: Date,
        label: "Last date this book was checked out",
        optional: true
    },
    summary: {
        type: String,
        label: "Brief summary",
        optional: true,
        max: 1000
    }
}));


if (Meteor.isClient) {
    Template.updateBookForm.helpers({
        editingDoc: function editingDocHelper() {
            return Books.findOne({_id: Session.get("selectedDocId")});
        }
    });

    Template.bookList.books = Books.find();
    Template.bookList.events({
        'click li': function (e) {
            Session.set("selectedDocId", this._id);
        }
    });
}
