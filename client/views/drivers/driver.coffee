Session.setDefault 'driverImage', '/images/200x200.jpg'

Template.driver.rendered = ->
  if @driverId
    Session.set 'driverImage', Drivers.findOne(_id: @driverId)?.picture
  else
    Session.set 'driverImage', '/images/200x200.jpg'

Template.driver.helpers
  driverImage: -> Session.get 'driverImage'

Template.driver.events
  'change #picture': (e, template) ->
    file = template.find('#picture').files[0]
    reader = new FileReader();
    reader.onload = (e) -> Session.set 'driverImage', e.target.result
    reader.readAsDataURL(file)