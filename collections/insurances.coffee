@Insurances = new Mongo.Collection 'insurances'
Partitioner.partitionCollection Insurances
Insurances.attachSchema Schema.insurance

Insurances.after.update (userId, doc, fieldNames, modifier, options) ->
  if doc.policyValidTo	
  	insuranceType = InsuranceTypes.findOne {_id: doc.insuranceType}
  	insuranceName = insuranceType?.name
  	event = CustomEvents.findOne { sourceId: doc._id }
  	if event
  	  CustomEvents.update(event._id, { $set: { date: doc.policyValidTo, name: "Застраховка: " + insuranceName}} )
  	else
  	  CustomEvents.insert
  	    sourceId: doc._id
  	    name: "Застраховка: " + insuranceName
  	    kind: "Застраховка"
  	    date: doc.policyValidTo
  	    vehicleId: doc.vehicle
  	    active: true
  	    seen: false  

Insurances.after.insert (userId, doc) ->
  if doc.policyValidTo
  	insuranceType = InsuranceTypes.findOne {_id: doc.insuranceType}
  	insuranceName = insuranceType?.name
  	CustomEvents.insert
      sourceId: doc._id
      name: "Застраховка: " + insuranceName
      kind: "Застраховка"
      date: doc.policyValidTo   
      vehicleId: doc.vehicle
      active: true
      seen: false
