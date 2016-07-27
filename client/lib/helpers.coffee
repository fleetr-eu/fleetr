Template.registerHelper 'session', (sessVar) ->
    EJSON.stringify Session.get(sessVar), {indent: true}
Template.registerHelper 'stringify', (obj) ->
    EJSON.stringify obj, {indent: true}
