Meteor.subscribe 'alarm-definitions'

Template.alarmDefinitionsList.created = () -> 
	#Session.set('show-add-alarm-definition', false)
  this.showAddAlarmDefinition = new ReactiveVar();
  this.showAddAlarmDefinition.set(false);

Template.alarmDefinitionsList.helpers
  opts: ->
   collection: AlarmDefinitions
   rowsPerPage: 15
   # fields: [
   #   { key: 'time', label: 'Time', fn: (val,obj) -> moment(val).format('DD/MM/YYYY HH:mm:ss') }
   #   { key: 'type', label: 'Type' }
   #   { key: 'lat', label: 'Latitude' }
   #   { key: 'lon', label: 'Longitude' }
   #   { key: 'speed', label: 'Speed' }
   #   { key: 'course', label: 'Course' }
   # ]
   showColumnToggles: true
   class: "table table-bordered table-hover"


Template.alarmDefinitionsList.helpers({  
  showAddAlarmDefinition: () -> Template.instance().showAddAlarmDefinition.get()
});

Template.alarmDefinitionsList.events
  'click #addAlarmDefinition': (event,template) ->
    template.showAddAlarmDefinition.set(true)
    #Session.set('show-add-alarm-definition', true)
    console.log 'ADD'
  'click #popupDialog': (event) ->
    #Session.set('show-add-alarm-definition', true)
    console.log 'Popup! ' + $('.mypopup')
    $('.mypopup').fadeOut()
