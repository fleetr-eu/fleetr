Meteor.methods
  'reports/proximity': (filter, location) ->
    @unblock()
    {coords, distance} = location
    locationIsValid = Array.isArray(coords) and coords.length is 2 and distance > 0
    console.log location, locationIsValid
    result = unless locationIsValid
      []
    else
      devices = Vehicles.find({}, {fields: unitId: 1}).map (v) -> v.unitId
      pipeline =
        [
          {$geoNear:
            query:
              deviceId: $in: devices
              'attributes.trip': $exists: true
            near:
              type: 'Point'
              coordinates: coords
            spherical: true
            includeLocs: "loc"
            maxDistance: distance
            distanceField: 'distance'
            num: 10000
          }
          {$project:
            recordTime: 1
            deviceId: "$deviceId"
            distance: 1
            tripId: "$attributes.trip"
          }
          {$lookup:
             from: "vehicles"
             localField: "deviceId"
             foreignField: "unitId"
             as: "vehicle"
          }
          {$sort: recordTime: 1}
          {$project:
            tripId: 1
            distance: 1
            vehicle: $arrayElemAt: ["$vehicle", 0]
            date:
              $dateToString:
                format: "%Y-%m-%d", date: "$recordTime"
            time:
              $dateToString:
                format: "%H:%M:%S", date: "$recordTime"
            ms:
              $dateToString:
                format: "%L", date: "$recordTime"
          }
          {$project:
            _id: $concat: ["$tripId", "@", "$date", "T", "$time", ".", "$ms"]
            date: 1
            time: 1
            tripId: 1
            distance: 1
            vehicleName:
              $concat: [ "$vehicle.name", " (", "$vehicle.licensePlate", ")" ]
            vehicleId: "$vehicle._id"
          }
          {$sort: date: -1}
        ]
      Logbook.aggregate(pipeline)
    result
