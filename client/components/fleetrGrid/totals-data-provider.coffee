# Slickgrid data provider that implements a grand total row
@TotalsDataProvider = (dataView, columns, grandTotalsColumns) ->
  totals = {}
  totalsMetadata =
    cssClasses: "totals"
    columns: {}
  emptyRowMetaData = columns: {}
  totalsMetadata.columns[i] = { editor: null, focusable: false } for i in [0..columns.length]
  emptyRowMetaData.columns[i] = { editor: null, focusable: false, formatter: -> '' } for i in [0..columns.length]

  emptyRow = {}
  emptyRow[columns[i]?.field] = '' for i in [0..columns.length]

  expandGroup: (key) -> dataView.expandGroup key
  collapseGroup: (key) -> dataView.collapseGroup key
  getLength: ->
    dl = if dataView.getLength() then dataView.getLength() else 0
    if grandTotalsColumns.length then dl + 2 else dl
  getItem: (index) ->
    dl = if dataView.getLength() then dataView.getLength() else 0
    if index < dl
      dataView.getItem index
     else if index == dl
      emptyRow
    else
      totals
  updateTotals: ->
    for column in grandTotalsColumns
      groups = dataView.getGroups()
      if groups && groups.length
        totals[column.field] = dataView.getGroups().reduce (total, group) ->
          total + (parseInt group.totals?.sum?[column.field] || 0)
        , 0
      else
        dl = if dataView.getLength() then dataView.getLength() else 0
        totals[column.field] = (parseInt dataView.getItem(idx)?[column.field] || 0 for idx in [0..dl-1])
        .reduce(((p, c) -> p + c), 0)
  getItemMetadata: (index) ->
    dl = if dataView.getLength() then dataView.getLength() else 0
    if index < dl
      dataView.getItemMetadata index
     else if index == dl
      emptyRowMetaData
    else
      totalsMetadata
