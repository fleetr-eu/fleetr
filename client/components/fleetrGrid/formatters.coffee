# Default column formatters
FleetrGrid.Formatters =
  dateFormatter: (row, cell, value) ->
    if value then new Date(value).toLocaleDateString 'en-US' else ''
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
    # remove the view if it had already been rendered before
    # rendering it again
    if @_blazeCache.views["#{row}:#{cell}"]
      Blaze.remove @_blazeCache.views["#{row}:#{cell}"]
    @_blazeCache.templates["#{row}:#{cell}"] = blazeTemplate
    # defer rendering of blazeTemplates
    Meteor.defer => @_renderBlazeTemplates()
    return "<div class='blazeTemplate' data-row='#{row}' data-col='#{cell}'></div>"

FleetrGrid.Formatters.sumEuroTotalsFormatter = FleetrGrid.Formatters.sumTotalsFormatter '&euro;'
FleetrGrid.Formatters.sumTotalsFormatterNoSign = FleetrGrid.Formatters.sumTotalsFormatter ''
