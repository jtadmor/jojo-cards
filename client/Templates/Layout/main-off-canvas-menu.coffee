### 

Events and handlers for:

- Main off canvas menu
- Select JoJo submenu
- Public JoJo submenu

###

#  -------------- MAIN MENU ------------------

Template.main_off_canvas_menu.helpers(

	# if the current jojo is public, the user who created it
	publicJoJoUser: () -> 
		if JoJoDB.findOne(Session.get("currentJoJo"))?.public
			user = Meteor.users.findOne( (JoJoDB.findOne(Session.get("currentJoJo")).userId) )
			user.username or user.profile.name

	home: () ->
		Session.equals('currentActivity', 'Welcome')

)

Template.main_off_canvas_menu.events(
)

# On render, load foundation
Template.main_off_canvas_menu.rendered = () -> 
	
	Meteor.setTimeout(() ->
		$(document).foundation(
			offcanvas: {close_on_click: true}	# Close the off canvas menu when the user clicks away
			# Other properties here as needed
		)
	, 500)

# ------------------ SELECTING PRIVATE JOJO --------------

Template.select_jojo_submenu.helpers(

	# Get all of a user's private jojos
	jojos: () -> 
		JoJoDB.find({userId: Meteor.userId(), public: false})
)



Template.select_jojo_submenu.events(

	# When activiating a jojo, set it to the currently active jojo, reset activity, route home
	'click .activateJoJo': (e) ->
		Session.set('currentJoJo', $(e.target).data('id'))
		Session.set('currentActivity', '')
)

# SELECTING / SEARCHING PUBLIC JOJOS 
Template.public_jojo_submenu.helpers({})