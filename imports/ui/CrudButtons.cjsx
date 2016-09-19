React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

module.exports = CrudButtons = React.createClass
  displayName: 'CrudButtons'

  add: ->
    console.log 'Add clicked'

    ModalForm.show @props.editItemTemplate,
      title: => "#{@props.i18nRoot}.title"
      data: {}

  render: ->
    <ul className="nav navbar-nav navbar-left">
      <li><a href="#" onClick={@add} className="btn btn-circle btn-default add-item">
        <i className="fa fa-plus"></i>
        Add
      </a></li>
    </ul>
