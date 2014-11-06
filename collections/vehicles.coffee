@Vehicles = new Mongo.Collection 'vehicles'

Vehicles.attachSchema Schema.vehicle

Vehicles.after.remove (userId, doc) ->
  if doc._id
    Locations.remove {vehicleId:doc._id}

Vehicles.findFiltered = (filterVar, fieldsToFilter) ->
  query = Session.get(filterVar).trim().replace ' ', '|'
  fields = fieldsToFilter.reduce (acc, field) ->
    term = {}
    if field == 'tags'
      term.tags = {$regex : ".*#{query}.*"}
    else
      term[field] =
        $regex: query
        $options: 'i'
    acc.push term
    acc
  , []
  console.log fields
  Vehicles.find $or: fields

Vehicles.helpers
  lastLocation: ->
    Locations.findOne {vehicleId: @_id}, {sort: {timestamp: -1}}
