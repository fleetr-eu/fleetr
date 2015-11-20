Template.insuranceType.rendered = ->
  AutoForm.getValidationContext("insuranceTypeForm").resetValidation()

Template.insuranceType.events
  "click .submit" : (e, t) -> t.$("#insuranceTypeForm").submit()

AutoForm.hooks
  insuranceTypeForm: onSuccess: -> Modal.hide()
