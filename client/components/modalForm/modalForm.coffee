options =
  backdrop: 'static'
  keyboard: false

Template.modalForm.events
  "click .submit" : (e, t) ->
    $("form").trigger 'modal-submit'

@ModalForm =
  show: (template, data) ->
    context =
      template: template
      data: data
    Modal.show 'modalForm', context, options

  hide: -> Modal.hide()
