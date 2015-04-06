Template.logbook.helpers
  selectedDateRange: ()-> Session.get('logbook-selected-date-range')
  selector: ()->
    # {date: '2015-03-18'}
    {}
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

Template.detailsCellTemplate.helpers
  rowDate: ()-> @date

Template.idleCellTemplate.helpers
  rowDate: ()-> @date

