@Countries = new Mongo.Collection 'countries'

Countries.allow
  insert: -> true
