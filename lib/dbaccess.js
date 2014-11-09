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
    Meteor.subscribe('allentries');
  });
};


// Set up allows / denies
if (Meteor.isServer) {
	
	JoJoDB.allow({

		// insert works on your own documents or if the jojo is public
		insert: function(userId, doc) {
			return (userId && doc.userId === userId) || (doc.public);
		},

		// update only works on your own documents that aren't public
		update: function(userId, doc) {
			return userId && doc.userId === userId && !doc.public;
		},

		// remove only works on your own documents (including public)
		remove: function(userId, doc) {
			return userId && doc.userId === userId;
		}

	});

	EntriesDB.allow({
		// Can insert only if into a public jojo 
		insert: function(userId, doc) {
			jojo = JoJoDB.find({_id: doc.jojoId});
			return userId && jojo.userId === userId || jojo.public;
		},

		// Cannot delete entries (can only disassociate them from a jojo)
		remove: function(userId, doc) {
			return false;
		}
	});

};
