# Helpers and Events for the top-bar 

Template.layout.events

	# Logout
	'click #user-logout': () ->
		Meteor.logout ()->
			Router.go '/'

Template.layout.rendered = () ->

	$(document).foundation('reflow')