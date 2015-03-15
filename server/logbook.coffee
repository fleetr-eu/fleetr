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
  query = {type:29}
  query.recordTime = args.recordTime if args.recordTime  
  console.log 'FILTER: ' + JSON.stringify(args)
  console.log 'QUERY: ' + JSON.stringify(query)
  subHandle = Logbook.find(query).observeChanges
    added: (id, fields) ->
      # console.log('Add: ' + JSON.stringify(fields))
      started = fields.io %2 == 1
      return if started == state
 
      if started 
        start = fields
      else
        stop = fields
        record = {start: start, stop: stop}
        distance = (stop.tacho-start.tacho)/1000
        seconds = moment(stop.recordTime).diff(moment(start.recordTime), 'seconds')
        
        record.startStopDistance = distance
        record.startStopSpeed =  (distance*3600/seconds)

        if not args.speed or record.startStopSpeed >= args.speed
          self.added("startstop", id, record)
        start = null
 
      state = started

    changed: (id, fields) ->
      #self.changed("testdata", id, fields);
    
    removed: (id) ->
      #self.removed("testdata", id);

  self.ready()
  self.onStop ()->  subHandle.stop()
  


