# Helpers and Events for the top-bar 

Template.layout.events

	# Logout
	'click #user-logout': () ->
		Meteor.logout ()->
			Router.go '/'

Template.layout.rendered = () ->

	# Initialize foundation when the accordion is rendered
	$(document).foundation('reflow')

Template.accordion_menu.rendered = () ->

	# Initialize foundation for the little elements
	$(document).foundation('reflow')