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
      "<b>#{sign} #{Math.round(parseFloat(val)*100)/100}</b>"
    else ''
  buttonFormatter: (row, cell, value, column, rowObject) ->
    render = (button) ->
      if button.renderer
        button.renderer button.value, row, cell, column, rowObject
      else "<button>#{button.value}</button>"
    buttons = (render button for button in column.buttons)
    buttons.join ''
  blazeFormatter: (blazeTemplate) -> (row, cell, value, column, rowObject) ->
    if value
      @_blazeCache.templates["#{row}:#{cell}"] = blazeTemplate
      setTimeout (=> @_renderBlazeTemplates(row,cell)), 0
      "<div class='blazeTemplate cell#{row}-#{cell}'></div>"
  decoratedNumberFormatter: (numberError, numberWarning, decimals=0 ) -> (row, cell, value) ->
    if value >= 0
      v = Number((Number(value)).toFixed(decimals))
      attnIcon = ""
      if v < numberError
        attnIcon = "<i class='fa fa-exclamation-triangle' style='color:red;' title='#{v}'></i>"
      else 
         if v < numberWarning 
          attnIcon = "<i class='fa fa-exclamation-triangle' style='color:orange;' title='#{v}'></i>"
      "<span>#{attnIcon}<div class='pull-right'>#{v}</div></span>"      
        

FleetrGrid.Formatters.sumEuroTotalsFormatter = FleetrGrid.Formatters.sumTotalsFormatter '&euro;'
FleetrGrid.Formatters.sumTotalsFormatterNoSign = FleetrGrid.Formatters.sumTotalsFormatter ''
