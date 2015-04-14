class TableFilter
  
  constructor: (columns)->  
    @columns = columns
    @selector = new ReactiveVar({})

  maxspeed: (speed) ->
    sel = @selector.get()
    if speed
      sel.maxSpeed = {$gt:speed}
    else
      delete sel.maxSpeed
    @selector.set(sel)      

  range: (range) ->
    sel = @selector.get()
    if range
      sel.date = range
    else
      delete sel.date
    @selector.set(sel)      

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
    @selector.set(sel)

total = new ReactiveVar({})

Template.logbook.helpers
  selector: ()-> daterange.get() 
  totalDistance: -> total.get().distance?.toFixed(0)
  totalFuel: -> (total.get().fuel/1000)?.toFixed(0)
  totalTravelTime: -> moment.duration(total.get().travelTime, "seconds").format('HH:mm:ss', {trim: false})
  totalIdleTime: -> moment.duration(total.get().idleTime, "seconds").format('HH:mm:ss', {trim: false})
  currentSelector: ()->  Template.instance().filter.selector.get()
  currentSelectorStr: ()->  JSON.stringify(Template.instance().filter.selector.get())
    
Template.logbook.events
  'click .table tr': (event,p)->
    td = $('td', event.currentTarget).eq(0).text()
    $(".table tr").removeClass('selected')
    event.currentTarget.classList.add('selected')
  'apply.daterangepicker #logbook-date-range': (event,p) ->
    startDate = $('#logbook-date-range').data('daterangepicker').startDate
    endDate = $('#logbook-date-range').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    console.log start + ' - ' + stop
    range = {$gte: start, $lte: stop}
    Template.instance().filter.range range
  'cancel.daterangepicker #logbook-date-range': (event,p) ->
    Template.instance().filter.range undefined


Template.detailsCellTemplate.helpers
  rowDate: ()-> @date

Template.idleCellTemplate.helpers
  rowDate: ()-> @date

Template.logbook.created = ()->
 this.filter = new TableFilter(['date', 'startAddress','stopAddress'])

Template.logbook.rendered = ()->
  self = this
  $table = $('.table')
  $input = $('#filter')
  $input.on 'keyup', ->
    console.log 'Key: ' + @value
    if parseInt(@value)
      self.filter.maxspeed parseInt(@value)
    else
      self.filter.value @value
      self.filter.maxspeed undefined

  Meteor.call 'aggByDateTotals', (err, res)-> 
    total.set(res[0]) if not err
  $('#logbook-date-range').daterangepicker
    startDate: moment().subtract('days', 29)
    endDate: moment()
    ranges: 
      'Today': [moment(), moment()],
      'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
      'Last 7 Days': [moment().subtract('days', 6), moment()],
      'Last 30 Days': [moment().subtract('days', 29), moment()],
      'This Month': [moment().startOf('month'), moment().endOf('month')],
      'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
    buttonClasses: ['btn btn-sm']
    applyClass: ' blue'
    cancelClass: 'default'
    format: 'DD/DD/YYYY'
    locale: 
      cancelLabel: 'Clear'
      daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
      monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
      firstDay: 1



