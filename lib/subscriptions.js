// Create collection for all JoJos
JoJoDB = new Mongo.Collection('jojos');

// Subscribe to all jojos
if (Meteor.isClient) {
  Meteor.startup ( function() {
  	// Grab the public and private list of JoJos
  	// Possibly put the subscribe calls in  a Tracker.autorun call so that whenever the userID changes, it will cancel and recreat the subscription
  	Meteor.subscribe('publicJoJos');
  	Meteor.subscribe('myJoJos');
    Meteor.subscribe('allUserData');
    Meteor.subscribe('currentUserData');

    // Publish the entries ids
  });
};


// Set up allows / denies
if (Meteor.isServer) {
	
	JoJoDB.allow({

		// insert works on your own documents or in public db
		insert: function(userId, doc) {
			return (userId && doc.userId === userId) || (doc.public);
		},

		// update only works on your own documents that aren't public
		update: function(userId, doc) {
			return userId && doc.userId === userId && !public;
		},

		// remove only works on your own documents (including public)
		remove: function(userId, doc) {
			return userId && doc.userId === userId;
		}

	});

};
