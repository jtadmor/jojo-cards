# Helpers and Events for the top-bar (which is the main layout)



Template.layout.events(

# Logout
	'click #user-logout': () ->
		Meteor.logout(()->
			Router.go('/')
		)
)


