autoformHooks = {}

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

  autoformHooks[autoformId] =
    onSuccess: -> ModalForm.hide()
    onError: (operation, error, template) -> # on validation error jump to the panel where the validation failed
      Meteor.defer ->
        id = template.$('.has-error').closest('div.tab-pane').attr('id')
        @$("a[href=##{id}]").tab('show')
  AutoForm.hooks autoformHooks

Template.modalForm.events
  "click .submit" : (e, t) -> t.$('form').submit()
  "keyup" : (e, t) -> ModalForm.hide() if e.keyCode is 27
