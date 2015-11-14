Template.confirmDelete.events
  'click .confirm-delete': ->
    Modal.hide()
    @action?()
