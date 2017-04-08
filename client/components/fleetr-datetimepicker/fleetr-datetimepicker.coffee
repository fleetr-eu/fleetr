Template.datetimepicker.onRendered ->
  $(@firstNode).datetimepicker @data.atts.opts

Template.datetimepicker.helpers atts: ->
  _.omit(@atts, 'opts')

AutoForm.addInputType 'datetimepicker',
  template: 'datetimepicker'
  valueOut: ->
    new Date(moment(@val(), Settings.shortDateTimeFormat).toDate())
  valueIn: (val)->
    if val
      moment(val).format(Settings.shortDateTimeFormat)
    else
      ''
