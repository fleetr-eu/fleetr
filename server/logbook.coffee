Meteor.publish 'startstoppub', ()->
  self = this

  state = false

  subHandle = Logbook.find({type:29}).observeChanges
    added: (id, fields) ->
      console.log('Add: ' + JSON.stringify(fields))
      started = fields.io %2 == 1
      if(started != state) 
        self.added("startstop", id, fields)
      state = started

    changed: (id, fields) ->
      #self.changed("testdata", id, fields);
    
    removed: (id) ->
      #self.removed("testdata", id);

  self.ready();
  self.onStop ()->  subHandle.stop()
  


