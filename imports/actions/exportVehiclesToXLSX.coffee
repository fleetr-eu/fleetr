XLSX  = require 'xlsx'
_     = require 'lodash'

exportedFields = [
  'name'
  'licensePlate'
  'allocatedToFleet'
  'allocatedToFleetFromDate'
  'odometer'
  'unitId'
  'fuelType'
  'maxFuelCapacity'
  'phoneNumber'
  'nextTechnicalCheck'
  'identificationNumber'
  'engineNumber'
  'color'
  'category'
  'makeAndModel'
  'kind'
  'productionYear'
  'maxPower'
  'engineDisplacement'
  'mass'
  'maxAllowedSpeed'
  'driver_id'
]

fields = {}
fields[f] = 1 for f in exportedFields

fmtDate = (d) -> moment(d).format('YYYY-MM-DD')

s2ab = (s) ->
  buf = new ArrayBuffer(s.length)
  view = new Uint8Array(buf)
  i = 0
  while i != s.length
    view[i] = s.charCodeAt(i) & 0xFF
    ++i
  buf

fleetrGrid = null
module.exports = (grid = fleetrGrid) ->
  fleetrGrid = grid

  # get filtered data from the grid
  data = fleetrGrid.grid.getData()
  # get active columns (in order)
  fields = fleetrGrid.grid.getColumns().map (c) -> c.field
  fields = _.difference fields, ['_id'] #omit id field

  # create array with only fields from visible columns
  i = 0
  mappedData = []
  while i < data.getLength()
    item = data.getItem i++
    mappedData.push _.pick item, fields

  sheet = XLSX.utils.json_to_sheet mappedData, headers: fields
  wb =
    SheetNames: ['Vehicles']
    Sheets: Vehicles: sheet

  wbout = XLSX.write(wb, {bookType:'xlsx', bookSST:true, type: 'binary'})
  blob = new Blob [s2ab(wbout)], type: "application/vnd.ms-excel;charset=utf-8"
  saveAs blob, "fleetr-vehicles-#{fmtDate moment()}.xlsx"
