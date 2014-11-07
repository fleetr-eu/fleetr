Session.setDefault 'driverImage', '/images/200x200.jpg'

Template.driver.rendered = -> Metronic.initSlimScroll '.scroller'

Template.driver.helpers
  driverSchema: -> Schema.driver
  driverImage: ->
    if @driverId then Drivers.findOne(_id: @driverId)?.picture else Session.get 'driverImage'
  driver: -> Drivers.findOne _id: @driverId

Template.driver.events
  'change #picture': (e, template) ->
    file = template.find('#picture').files[0]
    reader = new FileReader();
    reader.onload = (e) -> Session.set 'driverImage', e.target.result
    reader.readAsDataURL(file)
  "click .btn-sm" : (e) ->
    $("#driverForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("driverForm")

AutoForm.hooks
  driverForm:
    onSubmit: (insertDoc, updateDoc, currentDoc) ->
      @event.preventDefault()
      insertDoc.picture = updateDoc.$set.picture = Session.get 'driverImage'
      Meteor.call 'submitDriver', insertDoc, updateDoc
      @resetForm()
      Session.set 'driverImage', 'images/200x200.jpg'
      @done()
    onError: (operation, error, template) ->
      Meteor.defer ->
        id = template.$('.has-error').closest('div.tab-pane').attr('id')
        template.$("a[href=##{id}]").tab('show')
