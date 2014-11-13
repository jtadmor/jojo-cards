# Configure the default layout
Router.configure(
	layoutTemplate: 'layout'
)

# Data not found template
# NOTE: NOT ACTUALLY WORKING RIGHT NOW... 
# Router.plugin('dataNotFound', {dataNotFoundTemplate: 'access_denied'});

# Set up the template look-up convertor to return the string of the name
Router.setTemplateNameConverter((str) -> str)

# ---------- ROUTES ------------ 

# Homepage
Router.route('/',
	name: 'home'
	action: () ->
		Session.set('currentActivity', 'Welcome')
		Session.set('currentJoJo', '')
		@render()
)


# New Entries
Router.route('/newentry/:jojoId', 

	name: 'new_entry'

	# Set data context to the jojoId
	data: () ->
		JoJoDB.findOne({_id: @params.jojoId})
	
	action: () -> 
		Session.set('currentActivity', 'New Entry')
		Session.set('currentJoJo', @params.jojoId)
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

# Viewing (and editing) a profile
Router.route('/profile',
	name: 'profile'
	action: () ->
		Session.set('currentActivity', 'Profile')
		Session.set('currentJoJo', '')
		@render('profile')
)

# Viewing jojo entries
Router.route('/viewentries/:jojoId',
	name: 'displaying_entries'

	# Set the data context for the display by grabbing all the jojo entries
	# If there are queries, grab those to figure out which entries to display
	data: () ->
		# Field as a string to access dot notation in Mongo
		field = "data.#{@params.query.field}"
		value = @params.query.value
		# Create the query object
		query = {}
		query[field] = value
		
		# Return entries		
		EntriesDB.find({$and: [{jojoId : @params.jojoId}, query]}).fetch()
		
	

	# Update Session and render the template
	action: ()->
		Session.set('currentActivity', 'Viewing Entries')
		Session.set('currentJoJo', @params.jojoId)
		@render('displaying_entries')

)

# Viewing a jojo (and changing options / making public or private)
Router.route('/jojo/:jojoId',
	name: 'jojo_options'

	# Return the jojo
	data: () ->
		JoJoDB.findOne(@params.jojoId)

	# Update Session, render the template
	action: ()->
		Session.set('currentActivity', 'Viewing JoJo')
		Session.set('currentJoJo', @params.jojoId)
		@render('jojo_options')
)


