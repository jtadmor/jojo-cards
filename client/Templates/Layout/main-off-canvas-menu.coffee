# Events and handlers for:

# - Main off canvas menu
# - Select JoJo submenu
# - Public JoJo submenu

###

-------------- MAIN MENU ------------------

###

# On render, load foundation
Template.main_off_canvas_menu.rendered = () -> 
	
	Meteor.setTimeout(() ->
		$(document).foundation(
			offcanvas: {close_on_click: true}	# Close the off canvas menu when the user clicks away
			# Other properties here as needed
		)
	, 500)

# HELPERS
Template.main_off_canvas_menu.helpers(
#	user: return the user if there is a current public jojo (not in sandbox mode)
#	Used to display the user of the JoJo in the menu center
	publicUser: () -> 
		if JoJoDB.findOne(Session.get("currentJoJo"))?.public
			Meteor.users.findOne( (JoJoDB.findOne(Session.get("currentJoJo")).userId) ).username
)

# EVENT HANDLERS FOR THE MAIN MENU
Template.main_off_canvas_menu.events(

	'click #create-new-entry': () ->
		Session.set('currentActivity', 'New Entry')

	'click #create-new-jojo': () ->
		Session.set('currentActivity', 'Creating New JoJo')
		Session.set('newJoJoStep', 'Step One: Name Your JoJo')
)

###

------------------ SELECTING PRIVATE JOJO --------------

###

Template.select_jojo_submenu.helpers(

	# Get all of a user's private jojos
	jojos: () -> 
		JoJoDB.find({userId: Meteor.userId(), public: false})
)



Template.select_jojo_submenu.events(

	'click .activateJoJo': () -> 
	
	 # Change the currentJoJo on click
)

# SELECTING / SEARCHING PUBLIC JOJOS 
Template.public_jojo_submenu.helpers({})