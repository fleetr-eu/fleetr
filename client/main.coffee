require '/imports/startup/client.coffee'

@useAlpha = -> Session.set 'useAlpha', true
@disableAlpha = -> Session.set 'useAlpha', false
@isAlpha = -> Session.get('useAlpha') is true
