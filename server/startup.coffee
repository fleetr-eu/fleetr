
upgradeDatabase = () ->
  records = Logbook.find().fetch()
  console.log 'Records: ' + records.length
  for rec in records
 		# console.log 'Record: ' + JSON.stringify(rec)	
  	
  	if rec.speed2 and not rec.speed
  		speed = rec.speed2/100/1000*3600
  		Logbook.update(rec._id, {$set: {speed: speed}});
  		console.log '  upgrade: ' + rec.speed2 + ' => ' + rec.speed	

Meteor.startup ->
  Fiber = Npm.require('fibers')
  Fiber(upgradeDatabase).run()

  