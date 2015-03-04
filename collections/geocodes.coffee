@MyCodes = new Mongo.Collection 'mycodes'

MyCodes.allow {    'insert': (userId,doc) -> true }
  
MyCodes.findCachedLocationName = (lat,lon) -> 
  # console.log 'MyCodes: ' + MyCodes.find().count()
  doc = MyCodes.findOne {lat: lat, lon: lon}
  # console.log '  : ' + lat + ':' + lon + ' found: ' + doc
  doc


MyCodes.cacheLocationName = (lat,lon,address) ->
  doc = MyCodes.findOne {lat: lat, lon: lon}
  if doc
    console.log 'Cached: ' + JSON.stringify(doc)
    #MyCodes.update {_id: doc._id}, {$set: {address: address}}
  else
    doc = {lat: lat, lon: lon, address: address}
    console.log 'Insert cache: ' + JSON.stringify(doc)
    MyCodes.insert doc
  doc
