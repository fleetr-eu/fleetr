Meteor.subscribe 'drivers'
Meteor.subscribe 'countries'

Template.fleetr.helpers
  fakeParagraph: -> Fake.paragraph 15
