/*

Events and handlers for:

- Main off canvas menu
- Select JoJo submenu
- Public JoJo submenu

*/


// Helpers 
Template.off_canvas_menu.helpers({

	// Current: grab the current jojo's nice title
	currentJoJo: function() {
		return JoJoDB.findOne(Session.get("currentJoJo")).fetch().name;
	},
	// user: the user who created the current jojo
	user: function() {
		return JoJoDB.findOne(Session.get("currentJoJo")).fetch().user;
	},
});

Template.select_jojo_submenu.helpers({

	// Get all of a user's jojos
	jojos: function() {
		return JoJoDB.find({userId: Meteor.userId()}, public: false)
	}

});

Template.public_jojo_submenu.helpers({})