React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

CrudButtons = React.createClass
  displayName: 'CrudButtons'

  getDefaultProps: ->
    showMaintenancesButton: false
    showOdometerCorrectionButton: false
    showDocumentsButton: false
    showInsurancePaymentsButton: false

  add: ->
    ModalForm.show @props.editItemTemplate,
      title: => "#{@props.i18nRoot}.title"
      data: {}

  edit: ->
    ModalForm.show @props.editItemTemplate,
      title: => "#{@props.i18nRoot}.title"
      data:
        doc: => @props.doc

  delete: ->
    Modal.show 'confirmDelete',
      title: => "#{@props.i18nRoot}.title"
      message: => "#{@props.i18nRoot}.deleteMessage"
      action: => Meteor.call @props.removeItemMethod, @props.selectedItem

  render: ->
    if Roles.userIsInRole Meteor.user(), ["admin", "editor"]
      <ul className="nav navbar-nav navbar-left">
        <li><a href="#" onClick={@add} style={padding:'5px'}
                title={TAPi18n.__('button.add')}>
          <i className="pe-7s-plus" style={fontSize:'30px'}></i>
        </a></li>
        {if @props.doc
          [
            <li key='edit'><a href="#" onClick={@edit} style={padding:'5px'}
                title={TAPi18n.__('button.edit')}>
              <i className="pe-7s-pen" style={fontSize:'30px'}></i>
            </a></li>
          ,
            <li key='delete'><a href="#" onClick={@delete} style={padding:'5px'}
                title={TAPi18n.__('button.delete')}>
              <i className="pe-7s-trash" style={fontSize:'30px'}></i>
            </a></li>
          ]
        }
        {if @props.doc and @props.showMaintenancesButton
          <li>
            <a href={Router.path 'listMaintenances', vehicleId: @props.selectedItem}
                    style={padding:'5px'} title={TAPi18n.__('maintenances.listTitle')}>
              <i className="pe-7s-tools" style={fontSize:'30px'}></i>
            </a>
          </li>
        }
        {if @props.doc and @props.showOdometerCorrectionButton
          <li>
            <a href={Router.path 'listOdometers', vehicleId: @props.selectedItem}
                    style={padding:'5px'} title={TAPi18n.__('vehicles.odometers.listTitleShort')}>
              <i className="pe-7s-timer" style={fontSize:'30px'}></i>
            </a>
          </li>
        }
        {if @props.doc and @props.showDocumentsButton
          <li>
            <a href={Router.path 'listDocuments', driverId: @props.selectedItem}
                    style={padding:'5px'} title={TAPi18n.__("documentTypes.listTitle")}>
              <i className="pe-7s-news-paper" style={fontSize:'30px'}></i>
            </a>
          </li>
        }
        {if @props.doc and @props.showInsurancePaymentsButton
          <li>
            <a href={Router.path 'listInsurancePayments', insuranceId: @props.selectedItem}
                    style={padding:'5px'} title={TAPi18n.__('insurancePayments.listTitle')}>
              <i className="pe-7s-credit" style={fontSize:'30px'}></i>
            </a>
          </li>
        }
        {if @props.children
          <li style={borderLeft:'1px solid #9A9A9A', height: 50, margin: 5} />
        }
        {if @props.children
          @props.children
        }
      </ul>


module.exports = createContainer (props) ->
  selectedItem: selectedItem = Session.get 'selectedItemId'
  doc: if selectedItem then props.collection.findOne(_id: selectedItem) else null
, CrudButtons
