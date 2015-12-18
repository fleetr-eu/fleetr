
@DateRanges =
  history:
    'Today': [moment(), moment()],
    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
    'This Month': [moment().startOf('month'), moment().endOf('month')],
    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
  future:
    'Next 30 Days': [moment(), moment().add(29, 'days')]

@DateRangeFilter =
  install: (cssSelector, ranges = DateRanges.history) ->
    $(cssSelector).daterangepicker
      startDate: moment().subtract(29, 'days')
      endDate: moment()
      ranges: ranges
      buttonClasses: ['btn btn-sm']
      applyClass: ' blue'
      cancelClass: 'default'
      format: 'YYYY-MM-DD'
      locale:
        cancelLabel: 'Clear'
        daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        firstDay: 1
