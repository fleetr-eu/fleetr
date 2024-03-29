{ submitItem, removeItem, doIfEditor } = require '/imports/lib/db.coffee'

Meteor.methods
  submitGeofence: (doc) ->
    doIfEditor ->
      if Geofences.findOne(_id: doc._id)
        Geofences.update {_id: doc._id}, {$set: _.omit(doc, '_id')}
      else
        Geofences.insert doc

  removeGeofence: removeItem Geofences

  submitAlarm: submitItem Alarms
  removeAlarm: removeItem Alarms

  submitConfigurationSetting: submitItem ConfigurationSettings
  removeConfigurationSetting: removeItem ConfigurationSettings

  submitCustomEvent: submitItem CustomEvents
  removeCustomEvent: removeItem CustomEvents

  submitGeofenceEvent: submitItem GeofenceEvents
  removeGeofenceEvent: removeItem GeofenceEvents

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

  submitInsuranceCompany: submitItem InsuranceCompanies
  removeInsuranceCompany: removeItem InsuranceCompanies

  submitInsurance: submitItem Insurances
  removeInsurance: removeItem Insurances

  submitInsurancePayment: submitItem InsurancePayments
  removeInsurancePayment: removeItem InsurancePayments

  submitMaintenance: submitItem Maintenances
  removeMaintenance: removeItem Maintenances

  submitExpenseGroup: submitItem ExpenseGroups
  removeExpenseGroup: removeItem ExpenseGroups

  submitExpenseType: submitItem ExpenseTypes
  removeExpenseType: removeItem ExpenseTypes

  submitExpense: submitItem Expenses
  removeExpense: removeItem Expenses

  submitDocumentType: submitItem DocumentTypes
  removeDocumentType: removeItem DocumentTypes

  submitDocument: submitItem Documents
  removeDocument: removeItem Documents

  submitBusinessTrip: (doc, id) ->
    Trips.upsert tripId: id,
      $set:
        tripId: id
        isBusinessTrip: doc.$set.isBusinessTrip

  submitDriverVehicleAssignment: (doc, id) ->
    @unblock
    doIfEditor ->
      DriverVehicleAssignments.submit doc, id
      Drivers.update {_id: doc.$set.driver}, {$set: vehicle_id: doc.$set.vehicle}
      Vehicles.update {_id: doc.$set.vehicle}, {$set: driver_id: doc.$set.driver}
  removeDriverVehicleAssignment: (id) ->
    @unblock
    doIfEditor ->
      dva = DriverVehicleAssignments.findOne _id: id
      Drivers.update {_id: dva.driver}, {$unset: vehicle_id: ""}
      Vehicles.update {_id: dva.vehicle}, {$unset: driver_id: ""}
      DriverVehicleAssignments.remove _id: id
