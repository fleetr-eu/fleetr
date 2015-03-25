Template.vehicle.rendered = ->
  AutoForm.resetForm("vehicleForm")
  # i = 0
  # while i < 7
  #   $("#timepicker#{i}From").datetimepicker pickDate: false, language:Settings.locale
  #   $("#timepicker#{i}To").datetimepicker pickDate: false, language:Settings.locale
  #   i++
  Session.set "selectedMake", ""

Template.vehicle.helpers
  datePickerOptions :->
    todayBtn: "linked"
    language: "bg"
  vehicle: -> Vehicles.findOne _id: @vehicleId
  readonly: ->
    v = Vehicles.findOne _id: @vehicleId
    if v then true else false
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
    VehiclesModels.find(makeId:Session.get("selectedMake")).map (model) -> label: model.name, value: model._id


Template.vehicle.events
  "click .btn-sm" : (e) ->
    $("#vehicleForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("vehicleForm")
  'change select[name="make"]': (e, tpl) -> Session.set "selectedMake", tpl.$('select[name="make"]').val()

Template.timePickersForDay.helpers
  fromField:->
      "workingSchedule.#{@.seq}.from"
  toField:->
      "workingSchedule.#{@.seq}.to"

AutoForm.hooks
  vehicleForm:
    onError: (operation, error, template) ->
      Meteor.defer ->
        id = template.$('.has-error').closest('div.tab-pane').attr('id')
        @$("a[href=##{id}]").tab('show')
