#	currentJoJo: grab the current jojo's nice title
#	Used to display the title in the menu center
Template.registerHelper('currentJoJo', 
	() -> 
		if Session.get("currentJoJo") then JoJoDB.findOne(Session.get("currentJoJo")).jojo.name
)

# currentActivity: grab the current activity from the session variable, and if it hasn't been set, grab it from the URL
# Used to display the current activity
Template.registerHelper('currentActivity',
 () ->
		if not Session.get('currentActivity') 
			path = window.location.pathname.replace(/_/g, ' ').replace('/', '')
			Session.set('currentActivity', path)
		Session.get('currentActivity')
)