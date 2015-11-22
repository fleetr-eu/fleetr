submitItem = (collection) -> (doc, diff) ->
  @unblock()
  collection.submit doc, diff

removeItem = (collection) -> (doc) ->
  @unblock()
  collection.remove _id: doc

Meteor.methods
  submitGeofence: (doc) ->
    if Geofences.findOne(_id: doc._id)
      Geofences.update {_id: doc._id}, {$set: _.omit(doc, '_id')}
    else
      Geofences.insert doc

  removeGeofence: removeItem Geofences

  addLocation: (doc) ->
    @unblock()
    Locations.insert doc

  submitDriver: submitItem Drivers
  removeDriver: removeItem Drivers

  submitVehicle: submitItem Vehicles
  removeVehicle: removeItem Vehicles

  submitFleetGroup: submitItem FleetGroups
  removeFleetGroup: removeItem FleetGroups

  submitFleet: submitItem Fleets
  removeFleet: removeItem Fleets

  submitTyre: submitItem Tyres
  removeTyre: removeItem Tyres

  submitMaintenanceType: submitItem MaintenanceTypes
  removeMaintenanceType: removeItem MaintenanceTypes

  submitInsuranceType: submitItem InsuranceTypes
  removeInsuranceType: removeItem InsuranceTypes

  submitMaintenance: submitItem Maintenances

  submitExpenseGroup: submitItem ExpenseGroups
  removeExpenseGroup: removeItem ExpenseGroups

  submitExpenseType: submitItem ExpenseTypes
  removeExpenseType: removeItem ExpenseTypes

  submitExpense: submitItem Expenses
  removeExpenses: removeItem Expenses


  submitDriverVehicleAssignment: (doc, diff) ->
    @unblock
    DriverVehicleAssignments.submit(doc, diff)
    Drivers.update {_id: doc.driver}, {$set: vehicle_id: doc.vehicle}
    Vehicles.update {_id: doc.vehicle}, {$set: driver_id: doc.driver}

  removeDriverVehicleAssignment: removeItem DriverVehicleAssignments
