# Configure the default layout
Router.configure(
	layoutTemplate: 'layout'
)

# Set up the template look-up convertor to return the string of the name
Router.setTemplateNameConverter((str) -> str)

# ---------- ROUTES ------------ 

# Homepage
Router.route('/',
	name: 'home'
	action: () ->
		Session.set('currentActivity', 'Welcome')
		@render()
)


# New Entries
Router.route('/newentry/:jojoId', 

	name: 'new_entry'

	# Set data context to the jojoId
	data: () ->
		JoJoDB.findOne({_id: @params.jojoId})
	
	action: () -> 
		Session.set('current_Activity', 'New Entry')
		@render('new_entry')
)

# Creating New JoJo
Router.route('/createnewjojo',

	name: 'creating_new_jojo'
	action: () -> 
		Session.set('currentActivity', 'Creating New JoJo')
		Session.set('newJoJoStep', 'Step One: Name Your JoJo')
		@render('creating_new_jojo')
)

Router.route('/profile',
	name: 'profile'
	action: () ->
		Session.set('currentActivity', 'Profile')
		Session.set('currentJoJo', '')
		@render('profile')
)

# For the viewing entries router, subscribe to the entries by passing the jojoid, then use waitOn to make sure the subscription is ready