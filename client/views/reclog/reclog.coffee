# UNIT_TIMEZONE = '+0200' # should be configured probably in vehicle configuration

# Template.reclog.created = ->
#   @autorun ->
#     Meteor.subscribe 'logbook', {}


# Template.reclog.helpers
#   datafunc: ()->
#     () -> Logbook.find().fetch()
#   options:
#     columns: [
#       {title: 'Time' , sort: 'descending', data: (obj)->
#         moment(obj.recordTime).zone(UNIT_TIMEZONE).format('DD-MM HH:mm:ss')
#       }
#       {title: 'Type', data: 'type'}
#       {title: 'Distance', data: (obj)-> obj.distance?.toFixed(2)}
#   #     {key: 'tacho', label: 'Odo', fn: (val,obj)->
#   #       km = Math.floor(val/1000)
#   #       m = val%1000
#   #       km + ',' + m
#   #     }
#       {title: 'Speed', data: (obj)-> obj.speed}
#       {title: 'Interval', data: (obj)-> obj.interval}
#     ]
#     rowCallback: (row,data)->
#       console.log 'Row: ' + row + ' data: ' + data.type
#       rowClass = (item)->
#         return 'regular-row' if item.type == 30
#         return 'event-row' if item.type == 35
#         if item.type == 29
#           return if item.io%2 == 0 then 'stop-row' else 'start-row'
#         'unknown'
#       row.setAttribute('class', rowClass(data))
#
