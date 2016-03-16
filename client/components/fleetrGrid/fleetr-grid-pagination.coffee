Template.fleetrGridPagination.onRendered ->
  Meteor.defer =>
    dataView = @data.grid._dataView
    dataView.onPagingInfoChanged.subscribe (e, pagingInfo) ->
      console.log 'onPagingInfoChanged', pagingInfo
    console.log 'pagingInfo', dataView.getPagingInfo()
