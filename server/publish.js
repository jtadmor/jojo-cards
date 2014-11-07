// Publish public and private jojos
Meteor.startup( function() {
	Meteor.publish('publicJoJos', function() {
		
		// this.ready - do something?
		return JoJoDB.find({public: true});
	});

	// Will automatically re-publish when the userId changes
	Meteor.publish('myJoJos', function() {
		return JoJoDB.find({userId: this.userId});
	});

	// Publish user data
	Meteor.publish('allUserData', function() {
		return Meteor.users.find({}, {fields: {'username': 1, 'emails': 1, 'profile': 1}});
	});

	// Publish more information for the currently logged in user
	Meteor.publish('currentUserData', function() {
		return Meteor.users.find({_id: this.userId});
	});

});
