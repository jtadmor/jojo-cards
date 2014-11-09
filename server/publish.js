// Publish public and private jojos
Meteor.startup( function() {
	
	// JOJOS AND ENTRIES

	// All public jojos
	Meteor.publish('publicJoJos', function() {
		return JoJoDB.find({public: true});
	});

	// User's private jojos, auto-update on login / logout
	Meteor.publish('myJoJos', function() {
		return JoJoDB.find({userId: this.userId});
	});

	// ENTRIES

	// Publish all the entries for a particular jojo
	Meteor.publish('entries', function(jojoId) {
		
		// Find the jojo with jojoId, and return all entries with an _id contained in entries.entryIDs
		return EntriesDB.find({_id: {$in: JoJoDB.findOne({_id: jojoId}).entries.entryIDs}});
	});

	// USER DATA

	// All users, limited data
	Meteor.publish('allUserData', function() {
		return Meteor.users.find({}, {fields: {'username': 1, 'emails': 1, 'profile': 1}});
	});

	// Current user, all data
	Meteor.publish('currentUserData', function() {
		return Meteor.users.find({_id: this.userId});
	});

});
