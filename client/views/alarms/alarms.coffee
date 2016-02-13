Template.alarms.helpers
  options: ->
    i18nRoot: 'alarms'
    collection: Alarms
    editItemTemplate: 'alarm'
    removeItemMethod: 'removeAlarm'
    gridConfig:
      cursor: Alarms.find {},
        transform: (doc) -> _.extend doc,
            typeName: TAPi18n.__("alarmTypes.#{doc.type}")
      columns: [
        id: "timestamp"
        field: "timestamp"
        name: "#{TAPi18n.__('alarms.timestamp')}"
        width:20
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "typeName"
        field: "typeName"
        name: "#{TAPi18n.__('alarms.type')}"
        width:50
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "description"
        field: "description"
        name: "#{TAPi18n.__('alarms.description')}"
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "seen"
        field: "seen"
        name: "#{TAPi18n.__('alarms.seen')}"
        width:5
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

Template.seenAlarm.helpers
  checked: ->
    if @value then 'checked' else ''

Template.seenAlarm.events
  'change .active': (e, t) ->
    Meteor.call 'submitAlarm', @rowObject,
      $set:
        seen: e.target.checked
