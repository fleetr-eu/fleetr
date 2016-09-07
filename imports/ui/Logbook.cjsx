React             = require 'react'
{createContainer} = require 'meteor/react-meteor-data'
{AgGridReact}     = require 'ag-grid-react'


Logbook = React.createClass
  displayName: 'Logbook'

  dataSource: ->
    rowCount: @props.data.length
    getRows: ({startRow, endRow, successCallback, failCallback}) =>
      console.log 'getRows', startRow, endRow, successCallback, failCallback
      successCallback @props.data[startRow..endRow]

  columnDefs: -> [
    {headerName: "Date", field: "date", width: 150},
    {headerName: "StartTime", field: "startTime", width: 200},
    {headerName: "StopTime", field: "stopTime", width: 200},
    {headerName: "StartAddress", field: "startAddress", width: 200},
    {headerName: "StopAddress", field: "stopAddress", width: 200},
    {headerName: "Distance", field: "distance", width: 200},


  ]

  render: ->
    console.log 'render', @props
    <div className='ag-blue' style={height:'100%', width:'100%'}>
      <AgGridReact
        minRowsToShow=23
        paginationPageSize=23
        columnDefs={@columnDefs()}
        enableSorting=true
        enableFilter=true
        enableColResize=true
        rowModelType='pagination'
        datasource={@dataSource()}
      />
    </div>

c = new Mongo.Collection null
module.exports = createContainer (props) ->
  Meteor.subscribe('vehicle', _id: props.vehicleId)
  vehicle = Vehicles.findOne _id: props.vehicleId
  if vehicle and c.find({}).count() is 0
    Meteor.call 'vehicle/trips', {}, {timeRange: 'year', deviceId: vehicle.unitId}, (err, data) ->
      console.log 'got vehicle/trips'
      c.remove {}
      data.forEach (d) -> c.insert d

  data: c.find({}).fetch()
, Logbook
