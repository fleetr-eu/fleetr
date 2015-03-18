@TabularTables = {}

IDLE_DISTANCE_LIMIT = 0.01

Meteor.publish 'dateRangeAggregation', (args)->
    sub = this
    db = MongoInternals.defaultRemoteCollectionDriver().mongo.db
    rangeMatch = {$match: {}}
    if args
      rangeMatch = {$match: args}
    pipeline = [
      {$match: {type: 30}}
      rangeMatch
      {$project : {
          type: "$type",
          speed: "$speed",
          tacho: "$tacho",
          distance: "$distance",
          fuelUsed: "$fuelUsed",
          recordTime: "$recordTime",
          lat: "$lat",
          lon: "$lon",
          year: { $substr: ["$recordTime",0,4] },
          month: { $substr: ["$recordTime",5,2] },
          day: { $substr: ["$recordTime",8,2] },
          timestamp: "$interval",
        }
      },
      {$project : {
          type: "$type",
          speed: "$speed",
          tacho: "$tacho",
          distance: "$distance",
          fuelUsed: "$fuelUsed",
          recordTime: "$recordTime",
          lat: "$lat",
          lon: "$lon",
          date: { $concat: ["$year","-","$month","-","$day"] },
          timestamp: "$interval",
        }
      },
      { $group : {
            _id: "$date"
            total: { $sum: 1 }
            minSpeed: { $min: "$speed" }
            maxSpeed: { $max: "$speed" }
            avgSpeed: { $avg: "$speed" }

            sumDistance: { $sum: "$distance" }
            lastOdometer: { $last: "$tacho" }
            startTime: { $first: "$recordTime" }
            stopTime: { $last: "$recordTime" }
            sumFuel: { $sum: "$fuelUsed" }
            sumInterval: { $sum: "$interval" }

            startLat: { $first: "$lat" }
            stopLat: { $last: "$lat" }

            startLon: { $first: "$lon" }
            stopLon: { $last: "$lon" }

            # avgFuelUsed: { $avg: "$speed" }
        }}
    ]
    time = new Date().getTime()

    res = db.collection('logbook').aggregate pipeline, Meteor.bindEnvironment(
      (err, result) ->
        _.each result, (e) ->
          console.log 'Record: ' + JSON.stringify(e)
          sub.added "dateRangeAggregation", e._id, e if e.sumDistance > 0
        sub.ready()

      (error) ->
        Meteor._debug( "Error doing aggregation: " + error)
    )
    time = new Date().getTime() - time
    console.log 'Aggregated in: ' + time + 'ms'
    return res


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
  time = new Date().getTime()
  console.log 'Time: ' + time

  trackpoints = 0

  subHandle = Logbook.find(query).observeChanges
    added: (id, fields) ->
      # console.log('Add: ' + JSON.stringify(fields))
      if fields.type == 30
        old = maxSpeed
        maxSpeed = fields.speed if not maxSpeed or fields.speed > maxSpeed
        trackpoints++
        # console.log '  max speed: ' + old + ' ' + fields.speed + ' ==> ' + maxSpeed
      else if fields.type == 29  
        started = fields.io %2 == 1
        if started == state
          maxSpeed = null
          trackpoints = 0
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
          # else if trackpoints == 0
            # console.log 'Filter out: ' + args.speed + ' ' + record.startStopSpeed + ' ' + record.maxSpeed
          else if args.hideIdle and record.startStopDistance < IDLE_DISTANCE_LIMIT
            # console.log 'Filter out: ' + args.speed + ' ' + record.startStopSpeed + ' ' + record.maxSpeed
          else if args.speed and record.maxSpeed < args.speed
            # console.log 'Filter out: ' + args.speed + ' ' + record.startStopSpeed + ' ' + record.maxSpeed
          else
            # console.log 'Accepted: ' + args.speed + ' ' + record.startStopSpeed  + ' ' + record.maxSpeed + ' ' + (new Date().getTime() - time)
            self.added("startstop", id, record)
          start = null
          # console.log 'Stop: trackpoints: ' + trackpoints + "; max speed: " + maxSpeed
          maxSpeed = null
          trackpoints = 0

 
        state = started
      else
        #
    changed: (id, fields) ->
      #self.changed("testdata", id, fields);
    
    removed: (id) ->
      #self.removed("testdata", id);

  self.ready()
  console.log 'Find: ' + (new Date().getTime() - time) + 'ms'
  self.onStop ()->  subHandle.stop()
  


