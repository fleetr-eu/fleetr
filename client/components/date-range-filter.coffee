@DateRangeFilter =
  install: (cssSelector) ->
    $(cssSelector).daterangepicker
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
      format: 'YYYY-MM-DD'
      locale:
        cancelLabel: 'Clear'
        daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        firstDay: 1
