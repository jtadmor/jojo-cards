###

Template helpers and event handlers for creating a new jojo.

###

Template.creating_new_jojo.helpers(
	# Display text of step (and if user went directly here and 'newJoJoStep' has not yet been set, set it to step one)
	newJoJoStep: () ->
		if not Session.get('newJoJoStep')? then Session.set('newJoJoStep', 'Step One: Name Your JoJo')
		Session.get('newJoJoStep')

	# Helpers for which step it is
	step2: () ->
		Session.get('newJoJoStep').match(/Two|Three|Four/)

	step3: () ->
		Session.get('newJoJoStep').match(/Three|Four/)

	step4: () ->
		Session.get('newJoJoStep').match(/Four/)
)


Template.creating_new_jojo.events(

	# Events for moving to next step
	# Move the step up if on the prior step

	# Hit enter when submitting name to move on and insert a new jojo into the DB
	'keypress #set-jojo-title': (e) ->
		if Session.get('newJoJoStep').match(/One/)
			if e.which is 13
				Session.set('newJoJoStep', 'Step Two: Create The Form')
				# Create a new JoJoDB entry and set the currentJoJo
				id = JoJoDB.insert({username: Meteor.user().username, jojo: {name: $(e.target).val()} }, (err, id) ->
					if err then console.log err
					else
						console.log(id)
						Session.set('currentJoJo', id)
				)
		# No key press once the name is submitted
		else
			e.preventDefault()


	# Move up a step and open the create form modal
	'click #create-form': (e) ->
		if Session.get('newJoJoStep').match(/Two/) 
			Session.set('newJoJoStep', 'Step Three: Style The Entries')
		$('#create-form-modal').foundation('reveal','open')

	'click #style-entry': (e) ->
		Session.set('newJoJoStep', 'Step Four: Advanced Settings (optional)')
)