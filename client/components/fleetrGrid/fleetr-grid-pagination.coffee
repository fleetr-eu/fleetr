Template.fleetrGridPagination.onRendered ->
  Meteor.defer =>
    dataView = @data.grid._dataView
    setPageSize dataView, @data.pageSize or 10

    console.log 'pagingInfo', dataView.getPagingInfo()
    dataView.onPagingInfoChanged.subscribe (e, pagingInfo) ->
      console.log 'onPagingInfoChanged', pagingInfo

Template.fleetrGridPagination.events
  'click .nextPageButton': ->
    console.log 'next'
  'click .previousPageButton': ->
    console.log 'prev'
  'click .pageNumberButton': ->
    console.log 'clicked for page', @

Template.fleetrGridPagination.helpers
  pageNumbers: -> [0...2].map (x) -> x+1

setPageSize = (dataView, n) ->
  dataView.setRefreshHints isFilterUnchanged: true
  dataView.setPagingOptions pageSize: n
