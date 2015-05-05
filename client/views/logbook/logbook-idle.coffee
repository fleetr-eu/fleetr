class TableFilter
  
  constructor: (selectedDate, columns)->  
    @columns = columns
    @selector = new ReactiveVar({date: selectedDate})

  value: (value) ->
    sel = @selector.get()
    if value
      searches = []
      for column in @columns
        s = {}
        s[column] =
          $regex: value
          $options: 'i'
        searches.push s
      sel['$or'] = searches
    else
      delete sel['$or']
    console.log 'set: ' + JSON.stringify(sel)
    @selector.set(sel)

total = new ReactiveVar({})

Template.logbookIdle.created = ->
  Meteor.subscribe "vehicles"
  Meteor.subscribe "driverVehicleAssignments"
  Meteor.subscribe "drivers"
  this.filter = new TableFilter Template.currentData().selectedDate, [
    'location.city'
    'location.zipcode'
    'location.streetName'
  ]

Template.logbookIdle.rendered = ->
  self = this
  Meteor.call 'idleTotals', Template.currentData().selectedDate, (err, res)-> 
    if not err 
      console.log 'Idle: ' + JSON.stringify(res)
      if res[0] then total.set(res[0]) else total.set({idleTime:0})
  select = '<select id="selectDuration" aria-controls="DataTables_Table_0" class="form-control input-sm">
                  <option value="">all</option>
                  <option value="60">1 min</option>
                  <option value="300">5 min</option>
                  <option value="600">10 min</option>
                  <option value="1800">30 min</option>
                  <option value="3600">1 hour</option>
               </select>'
  $("#DataTables_Table_0_length").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_filter").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_length").parent().addClass("col-sm-4")
  $("#DataTables_Table_0_filter").parent().addClass("col-sm-8")
  $("#DataTables_Table_0_filter").prepend(select)

  $input = $('#filter')
  $input.on 'keyup', ->
    console.log 'Search: ' + @value
    self.filter.value @value


Template.logbookIdle.events
  'change #selectDuration': ->
    val = $('#selectDuration').val()
    console.log 'Selected: ' + val
    Session.set "selected-min-duration" , val

Template.logbookIdle.helpers
  selector: ()-> 
    search = {date: @selectedDate}
    if Session.get("selected-min-duration")
      duration = parseInt(Session.get("selected-min-duration")) 
      search.duration = {$gte: duration}
    console.log 'Search: ' + JSON.stringify(search)
    search
  totalIdleTime: -> moment.duration(total.get().idleTime, "seconds").format('HH:mm:ss', {trim: false})
  currentSelector: ()-> Template.instance().filter.selector.get()
  currentSelectorStr: ()-> JSON.stringify(Template.instance().filter.selector.get())

Template.mapIdleCellTemplate.helpers
  opts: -> encodeURIComponent EJSON.stringify
    deviceId: @deviceId
    start:
      time: moment(@startTime).valueOf()
      position:
        lat: @lat
        lng: @lon
    stop:
      time: moment(@stopTime).valueOf()
      position:
        lat: @lat
        lng: @lon

Template.idleDetailsCellTemplate.helpers
  datetime: ->
    date     : @date 
    startTime: @from()
    stopTime : @to()




