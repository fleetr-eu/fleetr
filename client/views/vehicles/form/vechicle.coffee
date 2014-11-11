Template.vehicle.rendered = ->
  $('#timepicker0From').datetimepicker pickDate: false
  $('#timepicker0To').datetimepicker pickDate: false
  $('#timepicker1From').datetimepicker pickDate: false
  $('#timepicker1To').datetimepicker pickDate: false
  $('#timepicker2From').datetimepicker pickDate: false
  $('#timepicker2To').datetimepicker pickDate: false
  $('#timepicker3From').datetimepicker pickDate: false
  $('#timepicker3To').datetimepicker pickDate: false
  $('#timepicker4From').datetimepicker pickDate: false
  $('#timepicker4To').datetimepicker pickDate: false
  $('#timepicker5From').datetimepicker pickDate: false
  $('#timepicker5To').datetimepicker pickDate: false
  $('#timepicker6From').datetimepicker pickDate: false
  $('#timepicker6To').datetimepicker pickDate: false
  $('#datepicker').datetimepicker

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
