Meteor.methods
  sendEmail: (to, subject, text) ->
    check [to, subject, text], [String]
    @unblock()
    Email.send
      to: to,
      from: 'no-reply@fleetr.eu',
      subject: subject,
      text: text
