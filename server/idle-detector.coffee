class @IdleDetector

  DistanceLimit = 100
  TimeLimit     = 60

  distance = 0
  seconds = 0
  resetTime = null
  resetLat = 0
  resetLon = 0

  idleStartTime = null

  stopped = false

  time: (time)->
    moment(time).zone(Settings.unitTimezone).format("HH:mm:ss")

  dtime: (time)->
    moment(time).zone(Settings.unitTimezone).format("DD-MM HH:mm:ss")

  date: (time)->
    moment(time).zone(Settings.unitTimezone).format("DD-MM")

  isodate: (time)->
    moment(time).zone(Settings.unitTimezone).format("YYYY-MM-DD")

  rectime: (record)->
    @dtime(record.recordTime)

  reset: (record)->
    # console.log '  reset...'
    distance = 0
    seconds = 0
    resetTime = record.recordTime
    resetLat = record.lat
    resetLon = record.lon
    idleStartTime = null

  process: (record)->
    if record.type is 29
      stopped = record.io == 254
      @reset(record) 
    if record.type is 35 and record.event is 1 #idle
      stopTime = moment(record.stime).toDate()
      seconds = (record.recordTime.getTime() - stopTime.getTime())/1000
      idle = 
        date     : @isodate(record.stime)
        startTime: record.stime
        stopTime : record.recordTime
        distance : undefined
        duration : seconds
        lat      : record.slat
        lon      : record.slon
        deviceId : record.deviceId
      interval = moment.duration(seconds, "seconds").format('HH:mm:ss', {trim: false})
      console.log 'IDLE DETECTED(EV35): ' + @date(record.stime) + ' [' + @time(record.stime) + ' - ' + @time(record.recordTime) + '] ' + interval + ' seconds: ' + seconds 
      @reset(record)
      return idle
    return if record.type isnt 30
    
    distance += record.distance
    seconds += record.interval

    # console.log moment(record.recordTime).zone(UNIT_TIMEZONE).format("DD-MM HH:mm:ss") + '[' + record.type + ' ' + record.distance.toFixed(0) + ' ' + record.interval.toFixed(0) + '] distance: ' + distance + ' seconds: ' + seconds
    time = @rectime(record)
    speed = (record.distance/1000/record.interval*3600)?.toFixed(2)
    console.log  time + ' [' + record.distance + ' ' + record.interval + ']\t distance: ' + distance + ' seconds: ' + seconds + ' speed: ' + speed

    if distance >= DistanceLimit
      if idleStartTime
        interval = moment.duration(seconds, "seconds").format('HH:mm:ss', {trim: false})
        seconds = (record.recordTime.getTime() - idleStartTime.getTime())/1000
        idle = 
          date     : @isodate(idleStartTime)
          startTime: idleStartTime
          stopTime : record.recordTime
          distance : distance
          duration : seconds
          lat      : resetLat
          lon      : resetLon
          deviceId : record.deviceId
        console.log 'IDLE DETECTED: ' + @date(idleStartTime) + ' [' + @time(idleStartTime) + ' - ' + @time(record.recordTime) + '] ' + interval + ' seconds: ' + seconds + ' distance: ' + distance
        idle.location = geocode(idle.lat, idle.lon)
      @reset(record)
      return idle
    else if seconds > TimeLimit and not stopped
      idleStartTime = resetTime
      console.log '  IDLE ' + @time(idleStartTime)
    else
      # nothing
    return null
