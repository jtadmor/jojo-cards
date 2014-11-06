// Handles login / logout events and registers the currentUsername helper

// Eventually this will change over to control everything through Meteor Accounts, but for now everything is auto-handled by accounts UI
Meteor.startup( function() {
	Accounts.ui.config({
		passwordSignupFields: 'USERNAME_AND_EMAIL'
	});
});
