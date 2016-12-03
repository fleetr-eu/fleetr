hiddenOnMobile = () ->
  Session.get('device-screensize') is 'small'

Template.configurationSettings.helpers

  options: ->
    i18nRoot: 'configurationSettings'
    collection: ConfigurationSettings
    editItemTemplate: 'configurationSetting'
    removeItemMethod: 'removeConfigurationSetting'
    
    gridConfig:
      pagination: true
      columns: [
        id: "category"
        field: "category"
        name: TAPi18n.__('configurationSettings.category')
        width: 40
        sortable: true
        search: where: 'client'
        align: 'left'
      ,
        id: "type"
        field: "type"
        name: TAPi18n.__('configurationSettings.type')
        width: 40
        sortable: true
        align: 'left'
        search: where: 'client'
      ,
        id: "name"
        field: "name"
        name: TAPi18n.__('configurationSettings.name')
        width: 40
        sortable: true
        align: 'left'
        search: where: 'client'  
      ,
        id: "value"
        field: "value"
        name: TAPi18n.__('configurationSettings.value')
        width: 40
        align: 'left'
        search: where: 'client'  
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: -> ConfigurationSettings.find {},
        sort:
          name: 1