// Publish public and private jojos

Meteor.publish('publicJoJos', function() {
	
	// this.ready - do something?
	return JoJoDB.find({public: true});

});

Meteor.publish('myJoJos', function() {
	if (this.userId) {
		return JoJoDB.find({userId: this.userId});
	}
	else {
		this.ready();
	}
});