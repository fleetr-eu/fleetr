Meteor.publish 'startstoppub', ()->
  self = this

  state = false

  start = null

  subHandle = Logbook.find({type:29}).observeChanges
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
  


