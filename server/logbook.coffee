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
  maxSpeed = null
  args = {} if not args
  query = {} #type:29}
  query.recordTime = args.recordTime if args.recordTime  
  console.log 'FILTER: ' + JSON.stringify(args)
  console.log 'QUERY: ' + JSON.stringify(query)
  subHandle = Logbook.find(query).observeChanges
    added: (id, fields) ->
      # console.log('Add: ' + JSON.stringify(fields))
      if fields.type == 30
        old = maxSpeed
        maxSpeed = fields.speed if not maxSpeed or fields.speed > maxSpeed
        # console.log '  max speed: ' + old + ' ' + fields.speed + ' ==> ' + maxSpeed
      else if fields.type == 29  
        started = fields.io %2 == 1
        if started == state
          maxSpeed = null
          # console.log 'Start'
          return
 
        if started 
          start = fields
        else
          stop = fields
          record = {start: start, stop: stop}
          distance = (stop.tacho-start.tacho)/1000
          seconds = moment(stop.recordTime).diff(moment(start.recordTime), 'seconds')
        
          record.startStopDistance = distance
          record.startStopSpeed =  (distance*3600/seconds)
          record.maxSpeed = maxSpeed
          if record.startStopDistance == 0
            # console.log 'Filter out: zero distance: ' + JSON.stringify(record)
          else if args.speed and record.maxSpeed < args.speed
            # console.log 'Filter out: ' + args.speed + ' ' + record.startStopSpeed + ' ' + record.maxSpeed
          else
            # console.log 'Accepted: ' + args.speed + ' ' + record.startStopSpeed  + ' ' + record.maxSpeed
            self.added("startstop", id, record)
          start = null
          maxSpeed = null
          # console.log 'Stop: ' + maxSpeed

 
        state = started
      else
        #
    changed: (id, fields) ->
      #self.changed("testdata", id, fields);
    
    removed: (id) ->
      #self.removed("testdata", id);

  self.ready()
  self.onStop ()->  subHandle.stop()
  


