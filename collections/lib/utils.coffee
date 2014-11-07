Mongo.Collection.prototype.findFiltered = (filterVar, fieldsToFilter) ->
  query = Session.get(filterVar).trim().replace ' ', '|'
  fields = fieldsToFilter.reduce (acc, field) ->
    term = {}
    term[field] =
      $regex: "#{query}"
      $options: 'i'
    acc.push term
    acc
  , []
  @find $or: fields
