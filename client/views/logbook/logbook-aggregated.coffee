daterange = new ReactiveVar({})

Template.logbook.helpers
  selector: ()-> daterange.get() 
  totalDistance: () ->
    total = 0
    AggByDate.find().forEach (rec)-> 
      total += rec.sumDistance
    total.toFixed(0) 
  totalTravelTime: () ->
    total = 0
    AggByDate.find().forEach (rec)-> 
      total += rec.sumInterval
    moment.duration(total, "seconds").format('HH:mm:ss', {trim: false})
  totalIdleTime: () ->
    total = 0
    AggByDate.find().forEach (rec)-> 
      total += rec.idleTime if rec.idleTime
    moment.duration(total, "seconds").format('HH:mm:ss', {trim: false})

Template.logbook.events
  'click .table tr': (event,p)->
    td = $('td', event.currentTarget).eq(0).text()
    console.log 'Click: ' + td
    $(".table tr").removeClass('selected')
    event.currentTarget.classList.add('selected')
  'apply.daterangepicker #logbook-date-range': (event,p) ->
    startDate = $('#logbook-date-range').data('daterangepicker').startDate
    endDate = $('#logbook-date-range').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    console.log start + ' - ' + stop
    range = {date: {$gte: start, $lte: stop}}
    daterange.set(range)
  'cancel.daterangepicker #logbook-date-range': (event,p) ->
    daterange.set({})


Template.detailsCellTemplate.helpers
  rowDate: ()-> @date

Template.idleCellTemplate.helpers
  rowDate: ()-> @date

Template.logbook.rendered = ()->
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



