# Helpers and Events for the top-bar (which is the main layout)

Template.top_bar.events(

# Logout
	'click #user-logout': () ->
		Meteor.logout(()->
			Router.go('/')
		)
)
