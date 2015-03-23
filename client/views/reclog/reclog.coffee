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

Template.reclog.rendered = ->
  select = '<select id="selectEventType" aria-controls="DataTables_Table_0" class="form-control input-sm">
                  <option value="">all</option>
                  <option value="29">29</option>
                  <option value="30">30</option>
                  <option value="35">35</option>
                  <option value="98">98</option>
               </select>'
  $("#DataTables_Table_0_length").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_filter").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_length").parent().addClass("col-sm-4")
  $("#DataTables_Table_0_filter").parent().addClass("col-sm-8")
  $("#DataTables_Table_0_filter").prepend(select)

Template.reclog.events
  'change #selectEventType': ->
      Session.set "selectedEventType" , $('#selectEventType').val()

Template.reclog.helpers
  selector: ->
      if Session.get("selectedEventType")
        {type: parseInt(Session.get("selectedEventType"))}
      else
        undefined
