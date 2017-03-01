doIfInRoles = (roles, cb) ->
  if Roles.userIsInRole Meteor.user(), roles
    cb?()
  else
    if Meteor.isClient
      sAlert.error
        sAlertIcon: 'exclamation'
        sAlertTitle: TAPi18n.__ 'alerts.error.title'
        message: TAPi18n.__ 'alerts.unauthorized.message'
    else
      throw new Meteor.Error TAPi18n.__('alerts.unauthorized.message')

doIfEditor = (cb) -> doIfInRoles ['editor'], cb

submitItem = (collection) -> (doc, id) ->
  @unblock()
  doIfEditor ->
    collection.submit doc, id

removeItem = (collection) -> (doc) ->
  @unblock()
  doIfEditor ->
    collection.remove _id: doc

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

  submitOdometers: submitItem Odometers
  removeOdometers: removeItem Odometers

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

  submitDriverVehicleAssignment: (doc) ->
    @unblock
    doIfEditor ->
      DriverVehicleAssignments.submit doc
      Drivers.update {_id: doc.driver}, {$set: vehicle_id: doc.vehicle}
      Vehicles.update {_id: doc.vehicle}, {$set: driver_id: doc.driver}
  removeDriverVehicleAssignment: (doc) ->
    @unblock
    doIfEditor ->
      DriverVehicleAssignments.remove _id: doc
      Drivers.update {_id: doc.driver}, {$unset: vehicle_id: ""}
      Vehicles.update {_id: doc.vehicle}, {$unset: driver_id: ""}
