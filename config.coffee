@AdminConfig =
  adminEmails: ['gantchok@yahoo.com', 'pokraev@gmail.com', 'babbata@gmail.com']
  collections:
    Drivers:
      icon: 'car'
      tableColumns: [
              {label: 'First Name', name: 'firstName'}
              {label: 'Last Name',name:'name'}
            ]
    Vehicles:
      icon: 'vehicle'
      tableColumns: [
              {label: 'License Plate', name: 'licensePlate'}
              {label: 'Identification Number',name:'identificationNumber'}
              {label: 'Allocated to Fleet', name: 'allocatedToFleet'}
              {label: 'Allocated from',name:'allocatedToFleetFrom'}
            ]
    Countries:
      icon: 'flag'
    Locations:
      icon: 'map-marker'
