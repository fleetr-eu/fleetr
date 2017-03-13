_ = require 'lodash'

module.exports =
  #
  # Creates event listeners on the google maps component. Callbacks are taken
  # from the react component's props. If a prop starts with 'on' it is considered
  # to be a callback. The text after 'on' is considered to be the google maps
  # component event name. Example, a prop called 'onClick' will result into a
  # 'click' eventListener on the google maps component. The arguments passed to
  # the eventListener are slightly altered. The first argument is the native google
  # maps event. The second argument is a reference to the native google maps component.
  # The third argument is the react component that wraps the google maps component.
  #
  # Callback signature: (event, nativeMapsComponent, reactWrapperComponent) ->
  #
  installListeners: (reactComp, googleComp) ->
    onCallbacks = _.filter (_.toPairs reactComp.props), ([key]) -> key.match /^on/
    onCallbacks.forEach ([key, cb]) ->
      eventName = _.toLower key[2..]
      googleComp.addListener eventName, (evt) -> cb evt, googleComp, reactComp
