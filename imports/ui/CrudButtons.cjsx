React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

CrudButtons = React.createClass
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
      {if @props.selectedItem
        [
          <li key='edit'><a href="#" className="btn btn-circle btn-default edit-item">
            <i className="icon-pencil"></i>
              Edit
          </a></li>
        ,
          <li key='delete'><a href="#" className="btn btn-circle btn-default delete-item">
            <i className="icon-trash"></i>
            Delete
          </a></li>
        ]
      }
    </ul>


module.exports = createContainer (props) ->
  selectedItem: Session.get 'selectedItemId'
, CrudButtons
