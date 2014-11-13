#	currentJoJo: grab the current jojo's nice title
Template.registerHelper('currentJoJoName', () -> if Session.get("currentJoJo") then JoJoDB.findOne(Session.get("currentJoJo"))?.name)

# currentJoJoId: current jojo's mongo ID
Template.registerHelper('currentJoJoId', () -> Session.get('currentJoJo') )

# currentActivity: return the string representing current activity
Template.registerHelper('currentActivity', () -> Session.get('currentActivity'))

# currentUserName: grab the current user's username, and if it does not exist, the name from the current user's profile
Template.registerHelper('currentUserName', () -> Meteor.user().username or Meteor.user().profile.name)

# jojoIcon: return the html string for displaying the small jojo icon
Template.registerHelper('jojoIcon', () -> '<img class=\"small-icon\" src=\"\/images\/jojo-icon.png\">')

# publicJoJoUser: return the name of the user that originated a public user
Template.registerHelper('publicJoJoUser', () -> 
		if JoJoDB.findOne(Session.get("currentJoJo"))?.public
			user = Meteor.users.findOne( (JoJoDB.findOne(Session.get("currentJoJo")).userId) )
			user.username or user.profile.name
)

# A helper for correctly grabbing the value of a textarea, preserving white space
$.valHooks.textarea = {
  get: (elem) -> 
      elem.value.replace( /\r?\n/g, "\r\n" )
}
