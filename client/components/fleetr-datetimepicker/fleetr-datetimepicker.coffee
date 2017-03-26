Template.datetimepicker.onRendered ->
  $(@firstNode).datetimepicker @data.atts.opts

Template.datetimepicker.helpers atts: ->
  _.omit(@atts, 'opts')

AutoForm.addInputType 'datetimepicker',
  template: 'datetimepicker'
  valueOut: ->
    moment(@val(), Settings.shortDateTimeFormat).toDate()
  valueIn: (val)->
    moment(val).format(Settings.shortDateTimeFormat)
