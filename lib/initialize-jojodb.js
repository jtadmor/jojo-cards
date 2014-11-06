// Create collection for all JoJos
JoJoDB = new Mongo.Collection('jojos');

// Subscribe to all jojos
if (Meteor.isClient) {
  Meteor.startup ( function() {
  	// Grab the public and private list of JoJos
  	// Possibly put the subscribe calls in  a Tracker.autorun call so that whenever the userID changes, it will cancel and recreat the subscription
  	Meteor.subscribe('publicJoJos');
  	Meteor.subscribe('myJoJos');
  });
}

/*
// On the server side, seed the db for any client that does not have the initial jojos

if (Meteor.isServer) {
  // On a successful login, check to see if the user has each of the starter jojos and create them if not
  Accounts.onLogin( function(attempt) {

  	// Inspirational Quotes
    if (!JoJoDB.findOne({username: attempt.user.username, $where: "this.jojo.name == 'Inspirational Quotes'"}) ) {

    	// Error check console log
    	console.log('Creating inspirational quotes');

    	// Create 

    	// Insert into JoJoDB
    	JoJoDB.insert()

    }
  });

  Accounts.onLoginFailure( function(attempt) {
  	console.log('Failed login');
  });

}

*/