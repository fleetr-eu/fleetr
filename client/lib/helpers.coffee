Template.registerHelper 'session', (sessVar) ->
    EJSON.stringify Session.get(sessVar), {indent: true}
