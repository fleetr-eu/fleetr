# TODO: some imports are made available globally for compatibility purposes
# with existing code. Existing code should be moved to the appropriate
# folder in /imports/.. and directly require the necessary libraries.

## Google maps markers
require '../ui/third-party/markerclusterer.js'
require '../ui/third-party/markerwithlabel.js'

## JQuery Plugins
# require '../ui/third-party/jquery-ui-1.10.3.custom.min.js'
require '../ui/third-party/jquery.slimscroll.min.js'

## Bootstrap Plugins
require '../ui/third-party/bootstrap-switch.min.js'
require '../ui/third-party/bootstrap-datepicker.bg.js'

## Metronic theme dependencies
@Metronic = require '../ui/third-party/metronic.js'
@Layout   = require '../ui/third-party/layout.js'
@Index    = require '../ui/third-party/index.js'

## Slickgrid dependencies
require '../ui/third-party/slickgrid/slick.core.js'
require '../ui/third-party/slickgrid/slick.formatters.js'
require '../ui/third-party/slickgrid/slick.grid.js'
require '../ui/third-party/slickgrid/slick.groupitemmetadataprovider.js'
require '../ui/third-party/slickgrid/slick.dataview.js'
require '../ui/third-party/slickgrid/plugins/slick.headerbuttons.js'
require '../ui/third-party/slickgrid/plugins/slick.rowselectionmodel.js'
require '../ui/third-party/slickgrid/plugins/slick.cellrangedecorator.js'
require '../ui/third-party/slickgrid/plugins/slick.cellrangeselector.js'
require '../ui/third-party/slickgrid/controls/slick.columnpicker.js'
require '../ui/third-party/slickgrid/controls/slick.pager.js'
