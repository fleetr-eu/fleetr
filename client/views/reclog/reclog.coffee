timeOfDay = (day, time) ->
  moment(day + ' ' + time + ' ' + Settings.unitTimezone)

Template.reclog.rendered = ->
  select = '<select id="selectEventType" aria-controls="DataTables_Table_0" class="form-control input-sm">
                  <option value="">all</option>
                  <option value="29">29</option>
                  <option value="30">30</option>
                  <option value="35">35</option>
                  <option value="98">98</option>
               </select>'
  $("#DataTables_Table_0_length").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_filter").parent().removeClass("col-sm-6")
  $("#DataTables_Table_0_length").parent().addClass("col-sm-4")
  $("#DataTables_Table_0_filter").parent().addClass("col-sm-8")
  $("#DataTables_Table_0_filter").prepend(select)

Template.reclog.events
  'change #selectEventType': ->
      Session.set "selectedEventType" , $('#selectEventType').val()

Template.reclog.helpers
  selector: ->
      search = {}
      search.type = parseInt(Session.get("selectedEventType")) if Session.get("selectedEventType")
      if @date
        datezoned = @date + ' ' + Settings.unitTimezone
        start = moment(datezoned).toDate()
        stop = moment(datezoned).add(1,'days').toDate()
        search.recordTime = {$gte: start, $lt: stop}
        if @startTime and @stopTime
          start = timeOfDay(@date, @startTime).toDate()
          stop = timeOfDay(@date, @stopTime).toDate()
          search.recordTime = {$gte: start, $lte: stop}
      search