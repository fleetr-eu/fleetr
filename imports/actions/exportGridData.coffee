XLSX  = require 'xlsx'
_     = require 'lodash'

delimiter = ','
fmtDate = (d) -> moment(d).format('YYYY-MM-DD')

s2ab = (s) ->
  buf = new ArrayBuffer(s.length)
  view = new Uint8Array(buf)
  i = 0
  while i != s.length
    view[i] = s.charCodeAt(i) & 0xFF
    ++i
  buf

module.exports = (fileName, format = "xslx", fleetrGrid = window.fleetrGrid) ->
  if fleetrGrid?.grid
    data = fleetrGrid.grid.getData()
    fieldNameLookupTable = _.extend.apply @, fleetrGrid.grid.getColumns().map (c) -> "#{c.field}": c.name
    fieldNames = fleetrGrid.grid.getColumns().map (c) -> c.name
    fields = fleetrGrid.grid.getColumns().map (c) -> c.field
    fields = _.difference fields, ['_id'] #omit id field

    i = 0
    rowData = []
    while i < data.getLength()
      item = data.getItem i++
      item = _.pick item, fields
      rowData.push item

    switch format
      when "xlsx"
        sheet = XLSX.utils.json_to_sheet rowData, headers: fieldNames
        sheet['!cols'] = fieldNames.map (field) -> wch: _.max rowData.map (row) -> "#{row[field]}".length
        wb =
          SheetNames: ['Fleetr']
          Sheets: Fleetr: sheet

        wbout = XLSX.write(wb, {bookType:'xlsx', bookSST:true, type: 'binary'})
        blob = new Blob [s2ab(wbout)], type: "application/vnd.ms-excel;charset=utf-8"
        saveAs blob, "#{fileName}-#{fmtDate moment()}.xlsx"
      when "csv"
        rows = rowData.map((row) -> _.values(row).map(JSON.stringify).join(delimiter) + "\n")
        blob = new Blob rows, type: "text/csv;charset=utf-8"
        saveAs blob, "#{fileName}-#{fmtDate moment()}.csv"
      else "Unsupported export format: #{format}"
  else
    "Can't get data from the gird. Grid instance is #{fleetrGrid}"
