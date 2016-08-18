React             = require 'react'
{createContainer} = require 'meteor/react-meteor-data'
{AgGridReact}     = require 'ag-grid-react'

Logbook = React.createClass
  displayName: 'Logbook'

  columnDefs: -> [
    {headerName: "Firstname", field: "f", width: 150},
    {headerName: "Lastname", field: "l", width: 200},
  ]

  rowData: -> [
    f: 'Jeroen'
    l: 'Peeters'
  ,
    f: 'Gantcho'
    l: 'Kojuharov'
  ]


  render: ->
    console.log 'render', @props
    <div className='ag-fresh'>
      <h1>Hello Logbook! {@props.vehicleId}</h1>
      <AgGridReact
        columnDefs={@columnDefs()}
        rowData={@rowData()}
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
