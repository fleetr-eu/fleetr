# Default column formatters
FleetrGrid.Formatters =
  dateFormatter: (row, cell, value) ->
    if value then moment(value).format('DD/MM/YYYY') else ''
  timeFormatter: (row, cell, value) ->
    moment(value).format('HH:mm:ss') if value
  dateTimeFormatter: (row, cell, value) ->
    moment(value).format('DD/MM/YYYY HH:mm:ss') if value
  roundFloat: (decimals = 0) -> (row, cell, value) ->
    Number((Number(value)).toFixed(decimals)) if value
  euroFormatter: (row, cell, value) ->
    "&euro; #{if value then value else '0'}"
  sumTotalsFormatter: (sign = '') -> (totals, columnDef) ->
    val = totals.sum && totals.sum[columnDef.field];
    if val
      "#{sign} " + ((Math.round(parseFloat(val)*100)/100));
    else ''
  buttonFormatter: (row, cell, value, column, rowObject) ->
    render = (button) ->
      if button.renderer
        button.renderer button.value, row, cell, column, rowObject
      else "<button>#{button.value}</button>"
    buttons = (render button for button in column.buttons)
    buttons.join ''
  blazeFormatter: (blazeTemplate) -> (row, cell, value, column, rowObject) ->
    @_blazeCache.templates["#{row}:#{cell}"] = blazeTemplate
    @_renderBlazeTemplates()
    "<div class='blazeTemplate' data-row='#{row}' data-col='#{cell}'></div>"

FleetrGrid.Formatters.sumEuroTotalsFormatter = FleetrGrid.Formatters.sumTotalsFormatter '&euro;'
FleetrGrid.Formatters.sumTotalsFormatterNoSign = FleetrGrid.Formatters.sumTotalsFormatter ''
