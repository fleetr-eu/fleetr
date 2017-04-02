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
  # can't do upsert, does not work well with the partitioner
  # TODO: check if this can be upserted now we don't use partitioner
  if id and @find({_id: id}, {limit: 1}).count()
    @update {_id: id}, { $set: _.omit(doc.$set, '_id'), $unset: _.omit(doc.$unset, '_id')}
  else
    @insert doc.$set or doc
