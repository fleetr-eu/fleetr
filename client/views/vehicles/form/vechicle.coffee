Template.vehicle.rendered = ->
  i = 0
  while i < 7
    $("#timepicker#{i}From").datetimepicker pickDate: false, language:Settings.locale
    $("#timepicker#{i}To").datetimepicker pickDate: false, language:Settings.locale
    i++

Template.vehicle.helpers
  vehicleSchema: -> Schema.vehicle
  vehicle: -> Vehicles.findOne _id: @vehicleId
  days:-> [
      {day:'Понеделник', seq:0}
      {day:'Вторник', seq:1}
      {day:'Сряда', seq:2}
      {day:'Четвъртък', seq:3}
      {day:'Петък', seq:4}
      {day:'Събота', seq:5}
      {day:'Неделя', seq:6}
    ]
  modelOptions:->
    VehiclesModels.find(makeId:@make).map (model) -> label: model.name, value: model._id


Template.vehicle.events
  "click .btn-sm" : (e) ->
    $("#vehicleForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("vehicleForm")

Template.timePickersForDay.helpers
  fromField:->
      "workingSchedule.#{@.seq}.from"
  toField:->
      "workingSchedule.#{@.seq}.to"
