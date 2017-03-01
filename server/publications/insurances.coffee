Meteor.publish 'insuranceTypes', -> InsuranceTypes.find {}
Meteor.publish 'insurancePayments', -> InsurancePayments.find {}
Meteor.publish 'insurances', -> Insurances.find {}

Meteor.publish 'insurance', (insId) ->
  Insurances.find _id: insId

Meteor.publish 'vehicleForInsurance', (insId) ->
  ins = Insurances.findOne _id: insId
  Vehicles.find {_id: ins.vehicle},
    fields:
      name: 1
      licensePlate: 1
