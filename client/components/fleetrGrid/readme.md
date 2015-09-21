# Fleetr Grid Documentation

Fleetr Grid is a component for displaying tabular data in a grid, much like Excel. Fleetr Grid is based on [Slick Grid](https://github.com/mleibman/SlickGrid/) and piggy backs heavily on its functionality. Essentially Fleetr Grid is a Slick Grid wrapper and provides higher level functions to improve the ease of use. It incorporates Meteor constructs such as DDP remote methods and Collection cursors.

## API

### new FleetrGrid options, columns, remoteMethod
Create a new instance.

- options: *Object* -  [Slick Grid Column Options Object](https://github.com/mleibman/SlickGrid/wiki/Grid-Options).
- columns: *Array* - Array of column definitions.
- remoteMethod: *String* - Name of DDP remote method.
