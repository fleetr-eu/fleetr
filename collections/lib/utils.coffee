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

Mongo.Collection.prototype.submit = (doc, diff) ->
  # after.insert is not triggered. remove after issues is fixed: https://github.com/matb33/meteor-collection-hooks/issues/16
  if @find({_id: doc._id}, {limit: 1}).count()
    @update {_id: doc._id}, {$set: _.omit(diff.$set, '_id'), $unset: _.omit(diff.$unset, '_id')}
  else
    @insert doc
