// Create collection for all JoJos and all entries
JoJoDB = new Mongo.Collection('jojos');
EntriesDB = new Mongo.Collection('entries');

// Subscribe to all jojos
if (Meteor.isClient) {
  Meteor.startup ( function() {
  	// Grab the public and private list of JoJos
  	// Possibly put the subscribe calls in  a Tracker.autorun call so that whenever the userID changes, it will cancel and recreat the subscription
  	Meteor.subscribe('publicJoJos');
  	Meteor.subscribe('myJoJos');
    Meteor.subscribe('allUserData');
    Meteor.subscribe('currentUserData');

    // Subscribe to entries
    Meteor.subscribe('accessibleEntries');
    Meteor.subscribe('newEntry');
  });
};


// Set up allows / denies
if (Meteor.isServer) {
	
	JoJoDB.allow({

		// insert works on your own documents or if the jojo is public
		insert: function(userId, doc) {
			return (userId && doc.userId === userId) || (doc.public);
		},

		// update only works on your own documents 
		update: function(userId, doc) {
			return userId && doc.userId === userId;
		},

		// remove only works on your own documents (including public)
		remove: function(userId, doc) {
			return userId && doc.userId === userId;
		}

	});

	EntriesDB.allow({
		// Can insert into a public jojo or your own
		insert: function(userId, doc) {
			jojo = JoJoDB.findOne(doc.jojoId);
			return userId && jojo.userId === userId || jojo.public;
		},

		// Can only remove from your own jojo (public or private)
		remove: function(userId, doc) {
			return false;
		},

		// Can update into a public jojo or your own
		update: function(userId, doc) {
			jojo = JoJoDB.findOne(doc.jojoId);
			return userId && jojo.userId === userId || jojo.public;
		}
	});

};
