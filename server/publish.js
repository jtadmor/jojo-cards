// Publish public and private jojos
Meteor.startup( function() {
	Meteor.publish('publicJoJos', function() {
		
		// this.ready - do something?
		return JoJoDB.find({public: true});
	});

	// Wait for login to publish the user's private dbs
	Meteor.publish('myJoJos', function() {
		username = Meteor.users.find({_id: this.userId}).username;
		return JoJoDB.find({username: username});
	});
});
