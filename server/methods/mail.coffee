Meteor.methods
  sendEmail: (to, subject, text) ->
    Email.send
      to: to,
      from: 'no-reply@fleetr.eu',
      subject: subject,
      text: text
