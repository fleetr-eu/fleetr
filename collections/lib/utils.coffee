Mongo.Collection.prototype.findFiltered = (filter, fieldsToFilter, findOptions) ->
  if filter
    fields = fieldsToFilter.reduce (acc, field) ->
      term = {}
      term[field] =
        $regex: filter
        $options: 'i'
      acc.push term
      acc
    , []
    @find
      $or: fields
    , findOptions || {}
  else
    @find {}, findOptions || {}

Mongo.Collection.prototype.submit = (doc, id) ->
  @upsert {_id: id}, { $set: _.omit(doc.$set, '_id'), $unset: _.omit(doc.$unset, '_id')}
