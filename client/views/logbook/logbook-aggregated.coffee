daterange = new ReactiveVar({})
total = new ReactiveVar({})

Template.logbook.helpers
  selector: ()-> daterange.get() 
  totalDistance: -> total.get().distance?.toFixed(0)
  totalFuel: -> (total.get().fuel/1000)?.toFixed(0)
  totalTravelTime: -> moment.duration(total.get().travelTime, "seconds").format('HH:mm:ss', {trim: false})
  totalIdleTime: -> moment.duration(total.get().idleTime, "seconds").format('HH:mm:ss', {trim: false})

Template.logbook.events
  'click .table tr': (event,p)->
    td = $('td', event.currentTarget).eq(0).text()
    # console.log 'Click: ' + td
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



