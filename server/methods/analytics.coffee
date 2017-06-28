Meteor.methods
  'analytics/month-vehicle-speed': ->
    @unblock()

    devices = Vehicles.find({}, {fields: unitId: 1}).map (v) -> v.unitId
    pipeline =
      [
        {$match:
          deviceId: $in: devices
        }
        {$group:
          _id:
            deviceId: "$deviceId"
            month:
              $dateToString:
                format: "%Y-%m"
                date: "$recordTime"
          maxSpeed: $max: "$speed"
          avgSpeed: $avg: "$speed"
          overspeeding: $sum: $cond: [$gt: ['$speed', 130], 1, 0]
        }
        {$lookup:
           {
             from: "vehicles"
             localField: "_id.deviceId"
             foreignField: "unitId"
             as: "vehicle"
           }
        }
        {$project:
          _id: 0
          month: "$_id.month"
          maxSpeed: 1
          avgSpeed: 1
          overspeeding: 1
          vehicle: $arrayElemAt: ["$vehicle", 0]
        }
        {$project:
          month: 1
          maxSpeed: 1
          avgSpeed: 1
          overspeeding: 1
          vehicle:
            $concat: [ "$vehicle.name", " (", "$vehicle.licensePlate", ")" ]
        }
        {$sort: overspeeding: -1}
        {$sort: month: -1}
      ]
    Logbook.aggregate(pipeline).reduce (result, elem) ->
      result[elem.month] ?= []
      result[elem.month].push elem
      result
    , {}
