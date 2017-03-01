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

delimiter = ','

label = (field) ->
  lbl = switch field
    when 'allocatedToFleet'
      TAPi18n.__('fleet.name')
    when 'driver_id'
      TAPi18n.__('vehicles.driverName')
    else
      Schema.vehicle._schema[field].label
  if typeof lbl is 'function' then lbl() else lbl

toCSV = (str) ->
  if String(str).includes(delimiter) then JSON.stringify(str) else str

header = ->
  hdr = (toCSV(label f) for f in exportedFields)
  "#{hdr.join delimiter}\n"

fmtDate = (d) -> moment(d).format('YYYY-MM-DD')

row = (vehicle) ->
  r = for k in exportedFields
    switch k
      when 'allocatedToFleet'
        toCSV vehicle.fleet().name
      when 'driver_id'
        toCSV vehicle.driver().fullName()
      when 'odometer'
        vehicle.odometerKm()
      when 'allocatedToFleetFromDate', 'nextTechnicalCheck'
        fmtDate vehicle[k]
      else
        toCSV vehicle[k]
  "#{r.join delimiter}\n"

fields = {}
fields[f] = 1 for f in exportedFields

module.exports = ->
  vehicles = Vehicles.find {},
    fields: fields
  .map row
  vehicles = [header(), vehicles...]
  blob = new Blob vehicles, type: "text/csv;charset=utf-8"
  saveAs blob, "fleetr-vehicles-#{fmtDate moment()}.csv"
