class @IdleDetector

  DistanceLimit = 100
  TimeLimit     = 60

  distance = 0
  seconds = 0
  resetTime = null
  resetLat = 0
  resetLon = 0

  idleStartTime = null

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
    @reset(record) if record.type is 29
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
        console.log 'IDLE DETECTED: ' + @date(idleStartTime) + ' [' + @time(idleStartTime) + ' - ' + @time(record.recordTime) + '] ' + interval + ' seconds: ' + seconds + ' distance: ' + distance
        idle.location = geocode(idle.lat, idle.lon)
      @reset(record)
      return idle
    else if seconds > TimeLimit
      idleStartTime = resetTime
      console.log '  IDLE ' + @time(idleStartTime)
    else
      # nothing
    return null
