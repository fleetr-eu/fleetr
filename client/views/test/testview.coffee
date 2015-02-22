Meteor.subscribe 'testData'

console.log 'TestData1: ' + TestData.find().count()
console.log 'TestData1: ' + TestData.find().count()

Pages = new Meteor.Pagination TestData

Template.postsList.helpers({
	posts: () -> 
		console.log 'TestData3: ' + TestData.find().count()
		TestData.find()
});
