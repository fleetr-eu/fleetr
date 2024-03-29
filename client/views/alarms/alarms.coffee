hiddenOnMobile = () ->
  Session.get('device-screensize') is 'small'

Template.alarms.helpers
  options: ->
    i18nRoot: 'alarms'
    collection: Alarms
    editItemTemplate: 'alarm'
    removeItemMethod: 'removeAlarm'
    additionalActionsTemplate: "additionalActionsTemplate"
    gridConfig:
      cursor: Alarms.find {},
        transform: (doc) -> _.extend doc,
            typeName: TAPi18n.__("alarmTypes.#{doc.type}"),
            timeAgo: moment(doc.timestamp).from(moment.utc()),
            date: if doc.timestamp then moment(doc.timestamp).format('DD/MM/YYYY') else ''
            time: if doc.timestamp then moment(doc.timestamp).format('HH:mm:ss') else ''
      columns: [
        id: "date"
        field: "date"
        name: "#{TAPi18n.__('alarms.timestamp')}"
        maxWidth:100
        sortable: true
        search: where: 'client'
        hidden: hiddenOnMobile()
        groupable: true
      ,
        id: "time"
        field: "time"
        name: "#{TAPi18n.__('alarms.timestampTime')}"
        maxWidth:80
        sortable: true
        hidden: hiddenOnMobile()
        search: where: 'client'
        groupable: true
      ,
        id: "timeAgo"
        field: "timeAgo"
        name: "#{TAPi18n.__('alarms.timeAgo')}"
        maxWidth:100
        sortable: true
        search: where: 'client'
      ,
        id: "typeName"
        field: "typeName"
        name: "#{TAPi18n.__('alarms.type')}"
        maxWidth:150
        hidden: hiddenOnMobile()
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "description"
        field: "description"
        name: "#{TAPi18n.__('alarms.description')}"
        maxWidth:450
        sortable: true
        groupable: true
        search: where: 'client'
      ,
        id: "seen"
        field: "seen"
        name: "#{TAPi18n.__('alarms.seenShort')}"
        maxWidth:30
        sortable: true
        search: where: 'client'
        groupable: true
        formatter: FleetrGrid.Formatters.blazeFormatter Template.seenAlarm
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
