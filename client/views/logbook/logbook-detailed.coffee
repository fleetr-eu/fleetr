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

Template.logbookStartStop.helpers
  selector: -> {date: @selectedDate}
  totalDistance: -> total.get().distance?.toFixed(0)
  totalFuel: -> (total.get().fuel/1000)?.toFixed(0)
  totalTravelTime: -> moment.duration(total.get().travelTime, "seconds").format('HH:mm:ss', {trim: false})
  currentSelector: ()-> Template.instance().filter.selector.get()
  currentSelectorStr: ()-> JSON.stringify(Template.instance().filter.selector.get())

Template.logbookStartStop.created = ()->
  Meteor.subscribe "vehicles"
  Meteor.subscribe "driverVehicleAssignments"
  Meteor.subscribe "drivers"
  console.log 'SelectedDate1: ' + Template.currentData().selectedDate
  this.filter = new TableFilter(Template.currentData().selectedDate, ['startAddress','stopAddress'])

Template.logbookStartStop.rendered = ()->
  self = this
  Meteor.call 'detailedTotals', Template.currentData().selectedDate, (err, res)-> 
    total.set(res[0]) if not err
  
  $input = $('#filter')
  $input.on 'keyup', ->
    console.log 'Search: ' + @value
    self.filter.value @value


Template.mapCellTemplate.helpers
  opts: -> encodeURIComponent EJSON.stringify
    deviceId: @start.deviceId
    start:
      time: moment(@start.recordTime).valueOf()
      position:
        lat: @start.lat
        lng: @start.lon
    stop:
      time: moment(@stop.recordTime).valueOf()
      position:
        lat: @stop.lat
        lng: @stop.lon

