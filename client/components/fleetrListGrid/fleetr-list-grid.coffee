getSelectedDocument = -> Template.instance().selectedDocument.get()

Template.fleetrListGrid.onCreated ->
  @selectedDocument = new ReactiveVar null

Template.fleetrListGrid.events
  'rowsSelected .fleetrListGrid': (event, tpl) ->
    unless e.rowIndex is -1
      tpl.selectedDocument.set event.fleetrGrid.getItemByRowId event.rowIndex
  'click #createLink': -> $('#slickgrid').trigger $.Event 'createLinkClicked'
  'click #editLink': -> $('#slickgrid').trigger $.Event 'editLinkClicked', document: getSelectedDocument()
  'click #deleteLink': -> $('#slickgrid').trigger $.Event 'deleteLinkClicked', document: getSelectedDocument()

Template.fleetrListGrid.helpers
  selectedDocument: getSelectedDocument
