@TabularTables = {}

# TabularTables.Logbook = new Tabular.Table 
#   name: "Logbook"
#   collection: Logbook
#   columns: [
#     {data: "lat", title: "Lat"}
#     {data: "lon", title: "Lon"}
#     {data: "speed", title: "Speed"}
#   ]

Meteor.publish 'startstoppub', (args)->
  self = this
  state = false
  start = null
  args = {} if not args
  args.type = 29
  console.log 'FILTER: ' + JSON.stringify(args)
  subHandle = Logbook.find(args).observeChanges
    added: (id, fields) ->
      # console.log('Add: ' + JSON.stringify(fields))
      started = fields.io %2 == 1
      return if started == state
 
      if started 
        start = fields
      else
        self.added("startstop", id, {start: start, stop: fields})
        start = null
 
      state = started

    changed: (id, fields) ->
      #self.changed("testdata", id, fields);
    
    removed: (id) ->
      #self.removed("testdata", id);

  self.ready()
  self.onStop ()->  subHandle.stop()
  


