### 

Events and handlers for:

- Main off canvas menu
- Select JoJo submenu
- Public JoJo submenu

###

#  -------------- MAIN MENU ------------------

Template.main_off_canvas_menu.helpers()

Template.main_off_canvas_menu.events(

# Logout
	'click #user-logout': () ->
		Meteor.logout()
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

# SELECTING / SEARCHING PUBLIC JOJOS 
Template.public_jojo_submenu.helpers(

	# Get all of the public jojos
	jojos: () ->
		JoJoDB.find({public: true})

)