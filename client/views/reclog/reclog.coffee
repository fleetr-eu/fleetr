UNIT_TIMEZONE = '+0200' # should be configured probably in vehicle configuration 

Template.reclog.created = ->
  @autorun ->
    Meteor.subscribe 'logbook', {}

Template.reclog.helpers
  opts: -> 
    collection: Logbook
    rowsPerPage: 50
    fields: [
      {key: 'recordTime', label: 'Time' , sort: 'descending', fn: (val,obj)-> 
        moment(val).zone(UNIT_TIMEZONE).format('DD-MM HH:mm:ss')
      }
      {key: 'type', label: 'Type'}
      {key: 'distance', label: 'Distance', fn: (val,obj)-> val}
      {key: 'tacho', label: 'Odo', fn: (val,obj)-> 
        km = Math.floor(val/1000)
        m = val%1000
        km + ',' + m
      }
      {key: 'speed', label: 'Speed', fn: (val,obj)-> val.toFixed(2)}
    ]
    showColumnToggles: true
    class: "table table-stripped table-hover start-stop-table"
    rowClass:(item)->
      return 'regular-row' if item.type == 30
      return 'event-row' if item.type == 35
      if item.type == 29
        return if item.io%2 == 0 then 'stop-row' else 'start-row'
      'unknown'



