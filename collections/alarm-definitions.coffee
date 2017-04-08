@AlarmDefinitions = new Mongo.Collection 'alarmDefinitions'

AlarmDefinitions.removeAll = () -> AlarmDefinitions.remove {}

Schema.alarmDefinitions = new SimpleSchema
  _id:
    type: String
    optional: true

  category:
    type: String
    optional: true
    label: 'Category'
    # autoform:
    #   firstOption: "(Изберете)"
    #   options: -> Fleets.find().map (fleet) -> label: fleet.name, value: fleet._id
    #   template: "bootstrap3-horizontal"
    #   "label-class": "col-sm-6"
    #   "input-col-class": "col-sm-6"

  name:
    type: String
    optional: true
    label: 'Name'

  daysBefore:
    type: Number
    optional: true
    label: 'Days Before'

  daysAfter:
    type: Number
    optional: true
    label: 'Days After'

  distanceBefore:
    type: Number
    optional: true
    label: 'Distance Before'

  distanceAfter:
    type: Number
    optional: true
    label: 'Distance After'


AlarmDefinitions.attachSchema Schema.alarmDefinitions
