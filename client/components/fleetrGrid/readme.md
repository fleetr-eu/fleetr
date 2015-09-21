# Fleetr Grid Documentation

Fleetr Grid is a component for displaying tabular data in a grid, much like Excel. Fleetr Grid is based on [Slick Grid](https://github.com/mleibman/SlickGrid/) and piggy backs heavily on its functionality. Essentially Fleetr Grid is a Slick Grid wrapper and provides higher level functions to improve the ease of use. It incorporates Meteor constructs such as DDP remote methods and Collection cursors.

## <a name="api"></a>API

### <a name="constructor"></a>new FleetrGrid options, columns, remoteMethod
Create a new instance.

- options: *Object* -  [Slick Grid Column Options Object](https://github.com/mleibman/SlickGrid/wiki/Grid-Options).
- columns: *Array* - Array of [column definitions](#column-definition).
- remoteMethod: *String* - Name of DDP remote method.

### *fleetrGrid*.install()
Installs the grid into the DOM. Before this call, the grid will not be *wired* into the HTML DOM. Normally, you would want to call this function in the Meteor [onRendered](http://docs.meteor.com/#/full/template_onRendered) callback of your template.

## <a name="column-definition"></a>Column definition
A column definition describes one column in the grid. You pass an *Array* of column definitions to the [constructor](#constructor) of FleetrGrid to define the functionality and dimension of the grid.

| Property  | Required? | Example / Possible values | Description
|-----------------------------------------------------------------
| id        | Y         |                             | unique identification
| name      | Y         |                             | column name
| field     | N         |                             | name of field in dataset
| width     | N         | 120                         | initial column with in pixels
| sortable  | N         | true / false                | is sorting allowed
| align     | N         | 'left' / 'right' / 'center' | text alignment of row cell
| formatter | N         | FleetrGrid.Formatters.dateFormatter | data formatter
| search    | N         |                             | pass a [search definition](#search-definition)

### <a name="search-definition"></a>Search definition
A column with a search definition can be queried by the user. Fleetr Grid creates
UI-elements that allow for real-time searching. It takes care to update the grid accordingly.
Depending on the type of search, the data is filtered directly in the browser (client search)
or the search parameters are passed to the *remoteMethod* with which the Fleetr Grid component
was instantiated (server search). In the last case the *remoteMethod* is responsible for
correctly filtering the data.

| Property  | Required? | Example / Possible values | Description
|-----------------------------------------------------------------
| where     | Y         | 'client' / 'server'       | unique identification
| dateRange | N         | [moment().startOf('month'), moment().endOf('month')] | [Moment.js](http://momentjs.com/) date range
