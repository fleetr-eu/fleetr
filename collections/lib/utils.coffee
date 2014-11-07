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

Mongo.Collection.prototype.submit = (doc, diff) ->
  @upsert {_id: doc._id}, {$set: _.omit(diff.$set, '_id'), $unset: _.omit(diff.$unset, '_id')}
