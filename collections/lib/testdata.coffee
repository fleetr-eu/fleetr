@TestData = new Meteor.Collection "testData"

N = 100
if Meteor.isServer and TestData.find().count() isnt N
	console.log 'TestData: inserting...'

	TestData.remove {}
	TestData._ensureIndex id: 1
	for i in [1 .. N]
		TestData.insert id: i
