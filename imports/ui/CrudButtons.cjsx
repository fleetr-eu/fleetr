React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

CrudButtons = React.createClass
  displayName: 'CrudButtons'

  getDefaultProps: ->
    showMaintenancesButton: false

  add: ->
    console.log 'Add clicked'

    ModalForm.show @props.editItemTemplate,
      title: => "#{@props.i18nRoot}.title"
      data: {}

  render: ->
    <ul className="nav navbar-nav navbar-left">
      <li><a href="#" onClick={@add} style={padding:'5px'} title="New">
        <i className="pe-7s-plus" style={fontSize:'30px'}></i>
      </a></li>
      {if @props.selectedItem
        [
          <li key='edit'><a href="#" style={padding:'5px'} title="Edit">
            <i className="pe-7s-pen" style={fontSize:'30px'}></i>
          </a></li>
        ,
          <li key='delete'><a href="#" style={padding:'5px'} title="Delete">
            <i className="pe-7s-trash" style={fontSize:'30px'}></i>
          </a></li>
        ]
      }
      {if @props.selectedItem and @props.showMaintenancesButton
        <li>
          <a href={Router.path 'listMaintenances', vehicleId: @props.selectedItem} style={padding:'5px'} title="Maintenance">
            <i className="pe-7s-tools" style={fontSize:'30px'}></i>
          </a>
        </li>
      }

    </ul>


module.exports = createContainer (props) ->
  selectedItem: Session.get 'selectedItemId'
, CrudButtons
