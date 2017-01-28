AutoForm.hooks
  vehicleForm:
    docToForm: (doc) ->
      doc.odometer = Math.round(doc.odometer / 1000) if doc.odometer
      doc
    formToModifier: (md) ->
      md.$set.odometer = md.$set.odometer * 1000 if md.$set.odometer
      md
