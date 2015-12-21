# Fleetr Grid Documentation

Fleetr Grid is a component for displaying tabular data in a grid, much like Excel. Fleetr Grid is based on [Slick Grid](https://github.com/mleibman/SlickGrid/) and piggy backs heavily on its functionality. Essentially Fleetr Grid is a Slick Grid wrapper and provides higher level functions to improve the ease of use. It incorporates Meteor constructs such as DDP remote methods and reactive collection cursors.

## <a name="api"></a>API

### <a name="constructor"></a>new FleetrGrid options, columns, remoteMethod
Create a new instance of FleetrGrid.

- options: *Object* -  [Slick Grid Column Options Object](https://github.com/mleibman/SlickGrid/wiki/Grid-Options).
- columns: *Array* - Array of [column definitions](#column-definition).
- serverMethodOrCursor: *String*/*Cursor*/*Function* - Name of DDP server method, a cursor instance or a reactive function that returns a cursor instance.

### *fleetrGrid*.install()
Installs the grid into the DOM. Before this call, the grid will not be *wired* into the HTML DOM. Normally, you would want to call this function in the Meteor [onRendered](http://docs.meteor.com/#/full/template_onRendered) callback of your template.

### *fleetrGrid*.destroy()
Destroys this grid instance, be sure to call this method in order to correctly unload and detach all event listeners and Blaze views.

## <a name="column-definition"></a>Column definition
A column definition describes one column in the grid. You pass an *Array* of column definitions to the [constructor](#constructor) of FleetrGrid to define the functionality and dimension of the grid.

| Property  | Required? | Example / Possible values | Description
|-----------|-----------|---------------------------|------------
| id        | Y         |                             | unique identification
| name      | Y         |                             | column name
| field     | N         |                             | name of field in dataset, visible in header cell
| width     | N         | 120                         | initial column with in pixels
| sortable  | N         | true / false                | is sorting allowed
| align     | N         | 'left' / 'right' / 'center' | text alignment of row cell
| formatter | N         | FleetrGrid.Formatters.dateFormatter | data formatter, see [data formatters](#data-formatters)
| search    | N         |                             | pass a [search definition](#search-definition)

### <a name="search-definition"></a>Search definition
A column with a search definition can be queried by the user. Fleetr Grid creates
UI-elements that allow for real-time searching. It takes care to update the grid accordingly.
Depending on the type of search, the data is filtered directly in the browser (client search)
or the search parameters are passed to the *remoteMethod* with which the Fleetr Grid component
was instantiated (server search). In the latter case the *remoteMethod* is responsible for
correctly filtering the data.
When the filter is run on the client, a custom filter function can be configured to be applied. By default a regular expression filter is executed.

| Property  | Required? | Example / Possible values | Description
|-----------|-----------|---------------------------|-------------
| where     | Y         | 'client' / 'server'       | where the filter is executed.
| dateRange | N         | [moment().startOf('month'), moment().endOf('month')] | [Moment.js](http://momentjs.com/) date range
| filter    | N         |  | See [custom filter](#custom-filter).

#### <a name="custom-filter"></a>Custom filter
Client filters can be customized by supplying a filter implementation. By default client filters use regular expressions to filter data, if you don't wan this then you need to implement a custom filter.

The signature of the filter implementaton is `(searchText) -> (columnValue) ->`.

The listing below shows an example filter implementation that matches on an item in an array. It also lists the example configuration.

    search:
      where: 'client'
      filter: (searchText) -> (columnValue) ->
        _.contains columnValue.map((e)->e.trim()), searchText

### <a name="data-formatters"></a>Data formatters
A data formatter formats the data for rendering in a cell. FleetrGrid comes with a couple of build-in formatters. All build-in formatters reside in the `FleetrGrid.Formatters` object. To use them, prepend the formatter name with `FleetrGrid.Formatters`.

| Formatter | Description
|-----------|--------------
| dateFormatter | Formats the cell value as a date (DD/MM/YYYY)
| timeFormatter | Formats the cell value as a time (HH:mm:ss)
| dateTimeFormatter| Formats the cell as date+time (DD/MM/YYYY HH:mm:ss)
| roundFloat | Rounds a floating point number. This formatter takes an optional argument to configure the number of decimals to round by. E.g. `roundFloat(2)`.
| euroFormatter | Prepends the cell value with a Euro currency symbol.
| blazeFormatter | Renders a Blaze template. See [Blaze templates in columns](#blaze-templates-in-columns)

#### <a name="laze-templates-in-columns"></a>Blaze templates in columns
FleetrGrid supports the rendering of Blaze templates in cell's. To render a template you must use the blazeFormatter. The blazeFormatter requires the template instance as argument. When the template is rendered FleetrGrid passes the following properties as the data-context to the Template.

    row: /row in the grid
    col: /column in the grid
    value: /the column value
    column: /the column instance
    rowObject: /the row object
    grid: /an instance to fleetrGrid

FleetrGrid manages the lifecycle of the Blaze view. All normal Blaze functionality is supported, including helpers, events and the created/destroyed callbacks.
