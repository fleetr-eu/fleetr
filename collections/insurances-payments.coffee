@InsurancePayments = new Mongo.Collection 'insurancePayments'
Partitioner.partitionCollection InsurancePayments
InsurancePayments.attachSchema Schema.insurancePayment

InsurancePayments.after.update (userId, doc, fieldNames, modifier, options) ->
   if doc.plannedDate
   	insurance = Insurances.findOne {_id: doc.insuranceId}
   	vehicleId = insurance?.vehicle
    event = CustomEvents.findOne { sourceId: doc._id }
    if event 
      CustomEvents.update(event._id, { $set: { date: doc.plannedDate, name: "Плащане по застраховка"}} )
    else
      CustomEvents.insert
        sourceId: doc._id
        name: "Плащане по застраховка"
        kind: "Плащане по застраховка"
        date: doc.plannedDate
        vehicleId: vehicleId
        active: true
        seen: false  

InsurancePayments.after.insert (userId, doc) ->
  if doc.plannedDate
   	insurance = Insurances.findOne {_id: doc.insuranceId}
   	vehicleId = insurance?.vehicle	
  	CustomEvents.insert
        sourceId: doc._id
        name: "Плащане по застраховка" 
        kind: "Плащане по застраховка"
        date: doc.plannedDate
        vehicleId: vehicleId
        active: true
        seen: false