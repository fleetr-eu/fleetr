Session.setDefault 'driverImage', 'images/200x200.jpg'

Template.driver.helpers
  driverSchema: -> Schema.driver
  driverImage: -> Session.get 'driverImage'

Template.driver.events
  'change #picture': (e, template) ->
    file = template.find('#picture').files[0]
    reader = new FileReader();
    reader.onload = (e) -> Session.set 'driverImage', e.target.result
    reader.readAsDataURL(file)

AutoForm.hooks
  driverForm:
    onSubmit: (insertDoc, updateDoc, currentDoc) ->
      @event.preventDefault()
      insertDoc.picture = Session.get 'driverImage'
      Meteor.call 'submitDriver', insertDoc
      @resetForm()
      Session.set 'driverImage', 'images/200x200.jpg'
      @done()
