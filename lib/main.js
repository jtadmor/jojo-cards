// All JoJos (private and public)
JoJoDB = new Meter.Collection('jojos');

if (Meteor.isClient) {
    Meteor.startup(function() {	
    	// Grab the public and private list of JoJos
    	// Possibly put the subscribe calls in  a Tracker.autorun call so that whenever the userID changes, it will cancel and recreat the subscription
    	Meteor.subscribe('publicJoJos');
    	Meteor.subscribe('myJoJos');
    })
}







if (Meteor.isServer) {
  Meteor.startup(function () {
    // Initialize Inspirational Quotes
    if (JoJoDB.find().count()===0) {
    	// Create inspirational Quotes
    }
  });

}
