getSelectedDocument = -> Template.instance().selectedDocument.get()

Template.fleetrListGrid.onCreated ->
  @selectedDocument = new ReactiveVar null

Template.fleetrListGrid.events
  'rowsSelected .fleetrListGrid': (event) ->
    Template.instance().selectedDocument.set event.fleetrGrid.data[event.rowIndex]
  'click #createLink': -> $('#slickgrid').trigger $.Event 'createLinkClicked'
  'click #editLink': -> $('#slickgrid').trigger $.Event 'editLinkClicked', document: getSelectedDocument()
  'click #deleteLink': -> $('#slickgrid').trigger $.Event 'deleteLinkClicked', document: getSelectedDocument()

Template.fleetrListGrid.helpers
  selectedDocument: getSelectedDocument
