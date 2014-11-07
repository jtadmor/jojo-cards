###

Template helpers and event handlers for creating a new jojo.

###

Template.creating_new_jojo.helpers(
	# Display text of step
	newJoJoStep: () ->
		# If user navigated directly to this URL or if the user refreshes at a later step but has lost the value of the jojo
		if $('set-jojo-title').val() is '' or not Session.get('newJoJoStep')
			Session.set('newJoJoStep', 'Step One: Name Your JoJo') 
		# Return the step
		Session.get('newJoJoStep')


	# Helpers for which step it is
	step2: () ->
		Session.get('newJoJoStep').match(/Two/)

	step3: () ->
		Session.get('newJoJoStep').match(/Three/)

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
				e.preventDefault()
				Session.set('newJoJoStep', 'Step Two: Create The Form')
				
				# Create a new JoJoDB entry and set the currentJoJo
				# Insert it with empty input array, empty entry array, public: false, and set the name and userId
				JoJoDB.insert({userId: Meteor.userId(), public: false, jojo: {name: $(e.target).val()}, inputs: [], entries: []}, (err, id) ->
					if err 
						console.log err
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
			# Update the session
			Session.set('newJoJoStep', 'Step Three: Style The Entries')

			# Render the template and open the modal
			Blaze.render(Template.create_form, $('#form-edit-modal')[0])
			$('#form-edit-modal').foundation('reveal','open')

	'click #style-entry': (e) ->
		if Session.get('newJoJoStep').match(/Three/)
			# Update session
			Session.set('newJoJoStep', 'Step Four: Advanced Settings (optional)')

			# Render the template and open the modal
			Blaze.render(Template.style_entry, $('#form-edit-modal')[0])
			$('#form-edit-modal').foundation('reveal','open')
)