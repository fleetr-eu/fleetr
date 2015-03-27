Template.logbook.helpers
  selectedDate: ()-> Session.get('logbook-selected-date')

Template.detailsCellTemplate.helpers
  rowDate: ()-> @date

Template.logbook.events
  'click .table tr': (event,p)->
    td = $('td', event.currentTarget).eq(0).text()
    console.log 'Click: ' + td
    $(".table tr").removeClass('selected')
    event.currentTarget.classList.add('selected')

