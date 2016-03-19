Template.fleetrGridPagination.onCreated ->
  @navState = new ReactiveVar {}

Template.fleetrGridPagination.onRendered ->
  Meteor.defer =>
    dataView = @data.grid._dataView
    setPageSize dataView, @data.pageSize or 10

    dataView.onPagingInfoChanged.subscribe (e, pagingInfo) =>
      updatePager @, pagingInfo

    updatePager @, dataView.getPagingInfo()

Template.fleetrGridPagination.events
  'click .nextPageButton': ->
    console.log 'next'
  'click .previousPageButton': ->
    console.log 'prev'
  'click .pageNumberButton': ->
    console.log 'clicked for page', @

Template.fleetrGridPagination.helpers
  pageNumbers: -> [0...Template.instance().navState.get()?.pagingInfo?.totalPages].map (x) -> x+1
  # navState: -> navState.get()
  pageNumberButtonClass: ->
    if Template.instance().navState.get()?.pagingInfo?.pageNum + 1 is @valueOf() then 'active' else ''
  previousPageButtonClass: -> if Template.instance().navState.get()?.canGotoPrev then '' else 'disabled'
  nextPageButtonClass: -> if Template.instance().navState.get()?.canGotoNext then '' else 'disabled'

setPageSize = (dataView, n) ->
  dataView.setRefreshHints isFilterUnchanged: true
  dataView.setPagingOptions pageSize: n

updatePager = (tpl, pagingInfo) ->
  console.log pagingInfo
  lastPage = pagingInfo.totalPages - 1
  tpl.navState.set
    canGotoFirst: pagingInfo.pageSize != 0 and pagingInfo.pageNum > 0
    canGotoLast: pagingInfo.pageSize != 0 and pagingInfo.pageNum != lastPage
    canGotoPrev: pagingInfo.pageSize != 0 and pagingInfo.pageNum > 0
    canGotoNext: pagingInfo.pageSize != 0 and pagingInfo.pageNum < lastPage
    pagingInfo: pagingInfo
