# Fleetr Grid Documentation

Fleetr Grid is a component for displaying tabular data in a grid, much like Excel. Fleetr Grid is based on [Slick Grid](https://github.com/mleibman/SlickGrid/) and piggy backs heavily on its functionality. Essentially Fleetr Grid is a Slick Grid wrapper and provides higher level functions to improve the ease of use. It incorporates Meteor constructs such as DDP remote methods and Collection cursors.

## API

### new FleetrGrid options, columns, remoteMethod
Create a new instance.

- options: *Object* -  [Slick Grid Column Options Object](https://github.com/mleibman/SlickGrid/wiki/Grid-Options).
- columns: *Array* - Array of column definitions.
- remoteMethod: *String* - Name of DDP remote method.

### *fleetrGrid*.install()
Installs the grid into the DOM. Before this call, the grid will not be *wired* into the HTML DOM. Normally, you would want to call this function in the Meteor [onRendered](http://docs.meteor.com/#/full/template_onRendered) callback of your template.
