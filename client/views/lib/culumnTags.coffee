Template.columnTags.helpers
  tagsArray: ->
    (@value?.split(",") || []).map ((n) => value: n.trim(), grid: @grid, column: @column)

Template.columnTags.events
  'click .label': ->
    @grid.setColumnFilterValue @column, @value
