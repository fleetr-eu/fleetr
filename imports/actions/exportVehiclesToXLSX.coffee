XLSX = require 'xlsx'

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

module.exports = ->
  vehicles = Vehicles.find {},
    fields: fields
  .map (v) ->
    v_ = {}
    for f in exportedFields
      v_[f] = if v[f] is null or v[f] is undefined then '' else v[f]
    v_



  console.log vehicles
  sheet = XLSX.utils.json_to_sheet vehicles


  wb =
    SheetNames: ['Sheet1']
    Sheets: Sheet1: sheet

  console.log(wb);

  wbout = XLSX.write(wb, {bookType:'xlsx', bookSST:true, type: 'binary'})
  blob = new Blob [s2ab(wbout)], type: "application/vnd.ms-excel;charset=utf-8"
  saveAs blob, "fleetr-vehicles-#{fmtDate moment()}.xlsx"
