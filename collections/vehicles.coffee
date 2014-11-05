@Vehicles = new Mongo.Collection 'vehicles'

Vehicles.attachSchema Schema.vehicle

Vehicles.after.remove (userId, doc) ->
  if doc._id
    Locations.remove {vehicleId:doc._id}

Vehicles.findFiltered = (filterVar, fieldsToFilter) ->
  filter =
    $regex: Session.get(filterVar).trim().replace ' ', '|'
    $options: 'i'
  fields = fieldsToFilter.reduce (acc, field) ->
    term = {}
    if field == 'tags'
      term.tags = {$regex : ".*"+filter+".*"}
    else
      term[field] = filter
    acc.push term
    acc
  , []
  Vehicles.find $or: fields

Vehicles.helpers
  lastLocation: ->
    Locations.findOne {vehicleId: @_id}, {sort: {timestamp: -1}}
