@ModalForm =
  show: (template, context) ->
    context.template = template
    Modal.show 'modalForm', context,
      backdrop: 'static'
      keyboard: false

  hide: -> Modal.hide()

Template.modalForm.onRendered ->
  autoformId = Template.instance().find('form').id
  AutoForm.getValidationContext(autoformId).resetValidation()

Template.modalForm.events
  "click .submit" : (e, t) ->
    t.$('form').submit()
    ModalForm.hide()
